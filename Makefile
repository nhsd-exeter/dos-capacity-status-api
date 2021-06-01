PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

OMIT := */tests/*,*/migrations/*,*apps.py,*asgi.py,*wsgi.py,*manage.py,*api/settings.py

# ==============================================================================
# Project targets: Dev workflow

build: project-config # Build project - mandatory: PROFILE=[profile name]
	make \
		api-build \
		proxy-build \
		data-build

restart: stop start # Restart project

start: project-start # Start project

stop: project-stop # Stop project

log: project-log # Show project logs

migrate:
	if [ "$(BUILD_ID)" != 0 ]; then
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			DB_DOS_HOST=db-dos-$(BUILD_ID) \
			API_DB_HOST=db-dos-$(BUILD_ID) \
			CMD="python manage.py migrate"
	else
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			CMD="python manage.py migrate"
	fi

test-db-start:
		make docker-compose-start-single-service NAME=db-dos

test: # Test project
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test api"

test-dos-interface: # Test dos interface
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test api/dos_interface/"

test-service: # Test service
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test api/service/"

test-authentication: # Test dos interface
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test api/authentication/"

test-regression-only: # Run only regression test suite
	if [ "$(BUILD_ID)" != 0 ]; then
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			DB_DOS_HOST=db-dos-$(BUILD_ID) \
			API_DB_HOST=db-dos-$(BUILD_ID) \
			CMD="python manage.py test --tag=regression api"
	else
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			CMD="python manage.py test --tag=regression api"
	fi

test-unit-only: # Run only unit test suite
	if [ "$(BUILD_ID)" != 0 ]; then
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			DB_DOS_HOST=db-dos-$(BUILD_ID) \
			API_DB_HOST=db-dos-$(BUILD_ID) \
			CMD="python manage.py test --exclude-tag=regression api"
	else
		make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
			DIR=application \
			CMD="python manage.py test --exclude-tag=regression api"
	fi

push: # Push project artefacts to the registry
	make docker-login
	make docker-push NAME=api
	make docker-push NAME=proxy
	make docker-push NAME=data

# ==============================================================================
# Project targets: Ops workflow

plan: # Show the creation instance plan - mandatory: PROFILE=[profile name]
	make terraform-plan \
		PROFILE=dev \
		NAME=$(or $(NAME), test)

deploy: # Deploy project - mandatory: PROFILE=[name], API_IMAGE_TAG=[docker tag], PROXY_IMAGE_TAG[docker-tag]
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make aws-assume-role-export-variables)"
	eval "$$(make populate-secret-variables)"
	make k8s-deploy STACK=service

deploy-job: # Deploy project - mandatory: PROFILE=[name], STACK=[stack], DATA_IMAGE_TAG=[docker tag]
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make populate-secret-variables)"
	make k8s-deploy-job STACK=$(STACK)

# ==============================================================================
# Supporting targets and variables

clean: # Clean up project
	make \
		api-clean \
		proxy-clean \
		data-clean
	rm -rfv $(HOME)/.python/pip

api-build:
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		manage.py \
		requirements.txt
	cd $(PROJECT_DIR)
	make ssl-copy-certificate-project DIR=$(PROJECT_DIR)/build/docker/api/assets/certificate
	make docker-image NAME=api

api-clean:
	make docker-image-clean NAME=api
	rm -rfv \
		$(DOCKER_DIR)/api/assets/*.tar.gz \
		$(DOCKER_DIR)/api/assets/certificate/certificate.* \
		$(PROJECT_DIR)/application/static

proxy-build:
	make docker-run-python \
		DIR=application \
		IMAGE=$(DOCKER_REGISTRY)/api:latest \
		CMD="pip install --upgrade pip && pip install -r requirements.txt && python manage.py collectstatic --noinput" SH=true
	make ssl-copy-certificate-project DIR=$(PROJECT_DIR)/build/docker/proxy/assets/certificate
	cp -rf \
		$(PROJECT_DIR)/application/static \
		$(DOCKER_DIR)/proxy/assets/application
	make docker-image NAME=proxy

proxy-clean:
	make docker-image-clean NAME=proxy
	rm -rfv \
		$(DOCKER_DIR)/proxy/assets/application/static \
		$(DOCKER_DIR)/proxy/assets/certificate/certificate.*

data-build: #PROFILE
	cp -fv \
		$(DATA_DIR)/aws-rds-sql/*.sql \
		$(DOCKER_DIR)/data/assets/data
	eval "$$(make aws-assume-role-export-variables)"
	eval "$$(make secret-fetch-and-export-variables NAME=$(DEPLOYMENT_SECRETS))"
	make file-replace-variables-in-dir DIR=$(DOCKER_DIR)/data/assets/data
	make docker-build NAME=data

data-clean:
	rm -rf $(DOCKER_DIR)/data/assets/data/*.sql
	make docker-image-clean NAME=data

# ---

# Populate generic secrets first (from deployment) and then environment specific so that env specific overwrite generic.
populate-secret-variables:
	if [ "$(PROFILE)" !=  "local" ]; then
		eval "$$(make aws-assume-role-export-variables)"
		make secret-fetch-and-export-variables NAME=$(DEPLOYMENT_SECRETS)
		echo "export API_DB_PASSWORD=$$(make -s secret-get-existing-value NAME=$(API_DB_PASSWORD_STORE))"
		echo "export API_ADMIN_PASSWORD=$$(make -s secret-get-existing-value NAME=$(API_PASSWORD_STORE))"
		echo "export DJANGO_SECRET_KEY=$$(make -s secret-get-existing-value NAME=$(DJANGO_SECRET_STORE))"
		echo "export API_DB_HOST=$(TF_VAR_db_dns_name)"

	fi
	if [ "$(PROFILE)" == "dev" ]; then
		echo "export DB_DOS_HOST=$(TF_VAR_db_dns_name)"
	fi
	if [ "$(PROFILE)" == "demo" ] || [ "$(PROFILE)" == "live" ]; then
		echo "export DB_DOS_PASSWORD=$$(make -s secret-get-existing-value NAME=$(DOS_SECRET_STORE) KEY=$(DOS_PASSWORD_KEY))"
	fi

# ---

# TODO: Do we really need this target?
api-start:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py runserver 0.0.0.0:8000" \
		ARGS="--publish 8000:8000"

# ---

project-generate-development-certificate: ssl-generate-certificate-project

trust-certificate: ssl-trust-certificate-project ## Trust the SSL development certificate

create-artefact-repository: ## Create Docker repositories to store artefacts
	make docker-create-repository NAME=api
	make docker-create-repository NAME=proxy
	make docker-create-repository NAME=data

# ---

dev-setup:
	make python-virtualenv

dev-clean:
	make python-virtualenv-clean
	rm -rf $(APPLICATION_DIR)/static

dev-db-start:
	make docker-compose-start-single-service NAME=db-dos

dev-build:
	cd $(APPLICATION_DIR)
	pip install -r requirements.txt
	python manage.py collectstatic --noinput

dev-migrate:
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DB_DOS_HOST=localhost
	python manage.py migrate

dev-start:
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DB_DOS_HOST=localhost
	export RESET_STATUS_IN_DEFAULT_MINS=$(SERVICE_RESET_STATUS_IN_DEFAULT_MINS)
	export RESET_STATUS_IN_MINIMUM_MINS=$(SERVICE_RESET_STATUS_IN_MINIMUM_MINS)
	export RESET_STATUS_IN_MAX_MINS=$(SERVICE_RESET_STATUS_IN_MAX_MINS)
	python manage.py runserver 0.0.0.0:8080

dev-create-user:
	password=$$(make secret-random)
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DB_DOS_HOST=localhost
	python manage.py user test $$password TestUser

dev-smoke-test:
	token=$$(make dev-create-user)
	service_id=153455
	curl -H "Authorization: Token $$token" http://localhost:8080/api/v0.0.1/capacity/services/$$service_id/capacitystatus/

url:
	echo https://$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(ENVIRONMENT)-proxy-ingress.$(TEXAS_HOSTED_ZONE)/api/v0.0.1/capacity/apidoc/

backup-data:
	eval "$$(make aws-assume-role-export-variables PROFILE=$(PROFILE))"
	make aws-rds-create-snapshot DB_INSTANCE=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(ENVIRONMENT) SNAPSHOT_NAME=$(GIT_TAG)
	make aws-rds-wait-for-snapshot SNAPSHOT_NAME=$(GIT_TAG)

# ==============================================================================
# Refactor

tag-images-for-production: ### Matches artefacts with Git Tag and triggers production pipeline - Mandatory: PROFILE=[demo|live], COMMIT=[git commit to progress], ARTEFACTS=[comma separated list of images]
	tag=$(BUILD_TIMESTAMP)-$(PROFILE)
	for image in $$(echo $(or $(ARTEFACTS), $(ARTEFACT)) | tr "," "\n"); do
		make docker-image-find-and-version-as \
			TAG=$$tag \
			NAME=$$image \
			COMMIT=$(COMMIT)
	done

project-get-production-tag:
	echo $(BUILD_TIMESTAMP)-$(PROFILE)

parse-profile-from-tag: ### Return profile based off of git tag - Mandatory GIT_TAG=[git tag]
	echo $(GIT_TAG) | cut -d "-" -f2

deployment-summary: ### Returns a deployment summary
	echo Terraform Changes
	cat /tmp/terraform_changes.txt | grep -E 'Apply...'
	echo Is deployment running?
	cat /tmp/deployment_stats.txt | grep -E 'Display namespaces' --after-context=100
	echo "Service URL Address: $$(make url)"

pipeline-send-notification:
	eval "$$(make aws-assume-role-export-variables)"
	eval "$$(make secret-fetch-and-export-variables NAME=$(DEPLOYMENT_SECRETS))"
	make slack-it

# ==============================================================================

.SILENT: \
	dev-create-user \
	dev-smoke-test \
	populate-secret-variables \
	parse-profile-from-tag \
	project-get-production-tag
