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
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py migrate"

migrate-jenkins:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		DB_DOS_HOST=db-dos-$(BUILD_ID) \
		API_DB_HOST=db-dos-$(BUILD_ID) \
		CMD="python manage.py migrate"

test-db-start:
	make docker-compose-start-single-service NAME=db-dos

test-db-start-jenkins: ### TEMPORARY
	make docker-compose-start-single-service NAME=db-dos-$(BUILD_ID)

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
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test --tag=regression api"

test-regression-only-jenkins: # Run only regression test suite
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		DB_DOS_HOST=db-dos-$(BUILD_ID) \
		API_DB_HOST=db-dos-$(BUILD_ID) \
		CMD="python manage.py test --tag=regression api"

test-unit-only: # Run only unit test suite
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test --exclude-tag=regression api"

test-unit-only-jenkins: # Run only unit test suite
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		DB_DOS_HOST=db-dos-$(BUILD_ID) \
		API_DB_HOST=db-dos-$(BUILD_ID) \
		CMD="python manage.py test --exclude-tag=regression api"

push: # Push project artefacts to the registry
	make docker-login
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
	make k8s-kubeconfig-get
	eval "$$(make k8s-kubeconfig-export)"
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy STACK=service
	# TODO: What's the URL?
	echo "The URL is $(UI_URL)"

deploy-job: # Deploy project - mandatory: PROFILE=[name]
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make aws-assume-role-export-variables)"
	make k8s-kubeconfig-get
	eval "$$(make k8s-kubeconfig-export)"
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy-job STACK=data

# ==============================================================================
# Supporting targets and variables

clean: # Clean up project
	make \
		api-clean \
		proxy-clean
	rm -rfv $(HOME)/.python/pip

api-build:
	make docker-run-python \
		DIR=application \
		CMD="" SH=true
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		static \
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

# ==============================================================================

.SILENT: \
	dev-create-user \
	dev-smoke-test \
	project-populate-application-variables \
	project-populate-db-pu-job-variables
