PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================

project-config:
	make docker-config

project-build: project-config project-stop
	make docker-image NAME=api
	make docker-image NAME=postgres

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
	# TODO: tar.gz / cp

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
