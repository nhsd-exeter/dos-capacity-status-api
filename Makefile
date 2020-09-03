PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

OMIT := */tests/*,*/migrations/*,*apps.py,*asgi.py,*wsgi.py,*manage.py,*api/settings.py

# ==============================================================================
# Project targets: Dev workflow

build: project-config # Build project
	make \
		api-build \
		proxy-build

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
	if [ "$(BUILD_ID)" != 0 ]; then
		make docker-compose-start-single-service NAME=db-dos-$(BUILD_ID)
	else
		make docker-compose-start-single-service NAME=db-dos
	fi

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
	# TODO: Do we still need the `VERSION` argument?
	make docker-push NAME=api VERSION=0.0.1
	make docker-push NAME=proxy VERSION=0.0.1

# ==============================================================================
# Project targets: Ops workflow

plan: # Show the creation instance plan - mandatory: PROFILE=[profile name]
	make terraform-plan \
		PROFILE=dev \
		NAME=$(or $(NAME), test)

deploy: # Deploy project - mandatory: PROFILE=[name]
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make aws-assume-role-export-variables)"
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy STACK=service
	# TODO: What's the URL?
	echo "The URL is $(UI_URL)"

deploy-job: # Deploy project - mandatory: PROFILE=[name], STACK=[stack]
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy-job STACK=$(STACK)

# ==============================================================================
# Supporting targets and variables

clean: # Clean up project
	make \
		api-clean \
		proxy-clean
	rm -rfv $(HOME)/.python/pip

api-build:
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		manage.py \
		requirements.txt
	cp -f \
		$(SSL_CERTIFICATE_DIR)/certificate.* \
		$(DOCKER_DIR)/api/assets/certificate
	cd $(PROJECT_DIR)
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
	cp -f \
		$(SSL_CERTIFICATE_DIR)/certificate.* \
		$(DOCKER_DIR)/proxy/assets/certificate
	cp -rf \
		$(PROJECT_DIR)/application/static \
		$(DOCKER_DIR)/proxy/assets/application
	make docker-image NAME=proxy

proxy-clean:
	make docker-image-clean NAME=proxy
	rm -rfv \
		$(DOCKER_DIR)/proxy/assets/application/static \
		$(DOCKER_DIR)/proxy/assets/certificate/certificate.*

# ---

project-populate-secret-variables:
	make secret-fetch-and-export-variables NAME=uec-dos-api-capacity-status-$(PROFILE)

# ---

# TODO: Do we really need this target?
project-clean-deploy: project-clean project-build project-push-images project-deploy

# TODO: Do we really need this target?
project-clean-build: project-clean project-build

# TODO: Do we really need this target?
api-start:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py runserver 0.0.0.0:8000" \
		ARGS="--publish 8000:8000"

# ---

project-generate-development-certificate: ssl-generate-certificate-project

project-trust-certificate: ssl-trust-certificate-project

create-artefact-repository: ## Create Docker repositories to store artefacts
	make docker-create-repository NAME=api
	make docker-create-repository NAME=proxy

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
	echo https://$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(PROFILE)-$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-proxy-ingress.$(TEXAS_HOSTED_ZONE)/api/v0.0.1/capacity/apidoc/

slack-it:
	eval "$$(make aws-assume-role-export-variables PROFILE=$(PROFILE))"
	eval "$$(make secret-fetch-and-export-variables NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)/deployment)"
	make slack-send-standard-notification NAME=jenkins-pipeline SLACK_EXTRA_DETAILS="Git Tag: $(GIT_TAG)"

backup-data:
	eval "$$(make aws-assume-role-export-variables PROFILE=$(PROFILE))"
	make aws-rds-create-snapshot DB_INSTANCE=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(AWS_ACCOUNT_NAME)-db SNAPSHOT_NAME=$(GIT_TAG)
	make aws-rds-wait-for-snapshot SNAPSHOT_NAME=$(GIT_TAG)

# ==============================================================================
# Refactor

# TODO: Remove it in favour of `secret-copy-value-from` once updated to the latest Make DevOps autoamtion scripts
secret-update-db-password: ### Update DB password for K8s deployment with new DB password
	eval "$$(make aws-assume-role-export-variables PROFILE=$(PROFILE))"
	pw=$$(make secret-fetch NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(AWS_ACCOUNT_NAME)-capacity_status_db_password)
	secrets=$$(make secret-fetch NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME)-$(PROFILE) | jq -rc --arg pw "$$pw" '.API_DB_PASSWORD = $$pw')
	echo $$secrets > $(TMP_DIR)/secrets-update.json
	file=$(TMP_DIR)/secrets-update.json
	make aws-secret-put NAME=$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME)-$(PROFILE) VALUE=file://$$file

git-create-tag: ### Tag PR to master for auto pipeline
	timestamp=$$(date --date=$(BUILD_DATE) -u +"%Y%m%d%H%M%S")
	commit=$$(make git-commit-get-hash)
	echo $$timestamp-$$commit

git-tag-is-present-on-branch: ### Returns true if the given branch contains the given tag else it returns false - mandatory: BRANCH=[branch name] TAG=[tag name]
	if [ $$(git branch --contains tags/$(TAG) | grep -ow $(BRANCH)) ]; then
		echo true
	else
		echo false
	fi

# ==============================================================================

.SILENT: \
	dev-create-user \
	dev-smoke-test \
	project-populate-application-variables \
	project-populate-db-pu-job-variables \
	git-tag-is-present-on-branch
