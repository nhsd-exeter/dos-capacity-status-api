PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================

project-config:
	make docker-config

project-build: project-config project-stop
	make docker-image NAME=api VERSION=0.0.1
	make docker-image NAME=postgres VERSION=0.0.1 NAME_AS=db
	make project-build-proxy

project-build-proxy:
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/proxy/assets/certificate
	make docker-image NAME=proxy VERSION=0.0.1

project-create-ecr:
	make docker-create-repository NAME=api
	make docker-create-repository NAME=db
	make docker-create-repository NAME=proxy

project-push-images: # Push Docker images to the ECR
	make docker-login
	make docker-push NAME=api VERSION=0.0.1
	make docker-push NAME=db VERSION=0.0.1
	make docker-push NAME=proxy VERSION=0.0.1

project-migrate:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
	DIR=application \
	CMD="python manage.py migrate"

project-restart:
	make \
		project-stop \
		project-start

project-start:
	make docker-compose-start YML=$(DOCKER_COMPOSE_YML)

project-stop:
	make docker-compose-stop YML=$(DOCKER_COMPOSE_YML)

project-log:
	make docker-compose-log YML=$(DOCKER_COMPOSE_YML)

project-clean:
	make docker-image-clean NAME=postgres

# ==============================================================================

api-build:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="pip install -r requirements.txt && python manage.py collectstatic --noinput" SH=true
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		logs \
		static \
		manage.py \
		requirements.txt

api-start:
	make docker-run-python IMAGE=$(DOCKER_REGISTRY)/api:latest \
		DIR=application \
		CMD="python manage.py runserver 0.0.0.0:8000" \
		ARGS="--publish 8000:8000"

# ==============================================================================

project-generate-certificate:
	make ssl-generate-certificate \
		DIR=$(PROJECT_DIR)/certificate \
		NAME=localhost

project-trust-certificate:
	make ssl-trust-certificate \
		FILE=$(PROJECT_DIR)/certificate/localhost.pem

# ==============================================================================

.SILENT:
