PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================

project-build: project-config project-stop # Build project
	make \
		api-build \
		db-build \
		proxy-build

project-test: # Test project
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py test api"

project-push-images: # Push Docker images to the ECR
	make docker-login
	make docker-push NAME=api VERSION=0.0.1
	make docker-push NAME=proxy VERSION=0.0.1

project-deploy: # Deploy to Kubernetes cluster - mandatory: PROFILE
	[ local == $(PROFILE) ] && exit 1
	eval "$$(make aws-assume-role-export-variables)"
	make k8s-kubeconfig-get
	eval "$$(make k8s-kubeconfig-export)"
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy STACK=service
	# TODO: What's the URL?
	echo "The URL is $(UI_URL)"

project-clean: # Clean up project
	make \
		api-clean \
		db-clean \
		proxy-clean
	rm -rfv $(HOME)/.python/pip

# ==============================================================================

api-build:
	make docker-run-python \
		DIR=application \
		CMD="pip install -r requirements.txt && python manage.py collectstatic --noinput" SH=true
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		static \
		manage.py \
		requirements.txt
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/api/assets/certificate
	cd $(PROJECT_DIR)
	make docker-image NAME=api VERSION=0.0.1

api-clean:
	make docker-image-clean NAME=api
	rm -rfv \
		$(DOCKER_DIR)/api/assets/*.tar.gz \
		$(DOCKER_DIR)/api/assets/certificate/certificate.* \
		$(PROJECT_DIR)/application/static

db-build:
	make docker-image NAME=postgres VERSION=0.0.1 NAME_AS=db

db-clean:
	make docker-image-clean NAME=postgres

proxy-build:
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/proxy/assets/certificate
	cp -rf \
		$(PROJECT_DIR)/application/static \
		$(DOCKER_DIR)/proxy/assets/application
	make docker-image NAME=proxy VERSION=0.0.1

proxy-clean:
	make docker-image-clean NAME=proxy
	rm -rfv \
		$(DOCKER_DIR)/proxy/assets/application/static \
		$(DOCKER_DIR)/proxy/assets/certificate/certificate.*

# ==============================================================================

project-migrate:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py migrate"

project-restart:
	make \
		project-stop \
		project-start

project-start:
	make docker-compose-start

project-stop:
	make docker-compose-stop

project-log:
	make docker-compose-log

project-populate-secret-variables:
	make secret-fetch-and-export-variables NAME=uec-dos-api-capacity-status-$(PROFILE)

# ==============================================================================

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

# ==============================================================================

project-config:
	make docker-config

project-generate-development-certificate:
	make ssl-generate-certificate \
		DIR=$(PROJECT_DIR)/certificate \
		NAME=certificate \
		DOMAINS='localhost,DNS:*.k8s-nonprod.texasplatform.uk,DNS:proxy:443'

project-trust-certificate:
	make ssl-trust-certificate \
		FILE=$(PROJECT_DIR)/certificate/certificate.pem

project-create-ecr:
	make docker-create-repository NAME=api
	make docker-create-repository NAME=proxy

# ==============================================================================

dev-setup:
	make python-virtualenv

dev-clean:
	make python-virtualenv-clean
	rm -rf $(APPLICATION_DIR)/static

dev-db-build:
	make db-clean db-build

dev-db-start:
	make docker-compose-start-single-service NAME=db-dos

dev-build:
	cd $(APPLICATION_DIR)
	pip install -r requirements.txt
	python manage.py collectstatic --noinput

dev-migrate:
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DOS_DB_HOST=localhost
	python manage.py migrate

dev-start:
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DOS_DB_HOST=localhost
	export RESET_STATUS_IN_DEFAULT_MINS=$(SERVICE_RESET_STATUS_IN_DEFAULT_MINS)
	export RESET_STATUS_IN_MINIMUM_MINS=$(SERVICE_RESET_STATUS_IN_MINIMUM_MINS)
	export RESET_STATUS_IN_MAX_MINS=$(SERVICE_RESET_STATUS_IN_MAX_MINS)
	python manage.py runserver 0.0.0.0:8080

dev-create-user:
	password=$$(make secret-random)
	cd $(APPLICATION_DIR)
	export API_DB_HOST=localhost
	export DOS_DB_HOST=localhost
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
