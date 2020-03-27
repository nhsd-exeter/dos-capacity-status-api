PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(abspath $(PROJECT_DIR)/build/automation/init.mk)

# ==============================================================================

project-config:
	make docker-config

project-clean-deploy: project-clean project-build project-push-images project-deploy

project-clean-build: project-clean project-build

project-build: project-config project-stop
	make project-build-api
	make project-build-postgres
	make project-build-proxy

project-build-postgres:
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/postgres/assets/etc/postgresql/certificate
	make docker-image NAME=postgres VERSION=0.0.1 NAME_AS=db

project-build-api:
	cd $(APPLICATION_DIR)
	tar -czf $(PROJECT_DIR)/build/docker/api/assets/api-app.tar.gz \
		api \
		logs \
		static \
		manage.py \
		requirements.txt
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/api/assets/certificate
	cd $(PROJECT_DIR)
	make docker-image NAME=api VERSION=0.0.1

project-build-proxy:
	cp -f \
		$(PROJECT_DIR)/certificate/* \
		$(DOCKER_DIR)/proxy/assets/certificate
	cp -f -r \
		$(PROJECT_DIR)/application/static/* \
		$(DOCKER_DIR)/proxy/assets/application/static
	make docker-image NAME=proxy VERSION=0.0.1

project-create-ecr:
	make docker-create-repository NAME=api
	make docker-create-repository NAME=proxy

project-push-images: # Push Docker images to the ECR
	make docker-login
	make docker-push NAME=api VERSION=0.0.1
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

project-clean: project-stop
	make docker-image-clean NAME=postgres
	make docker-image-clean NAME=api
	make docker-image-clean NAME=proxy

project-deploy:
	eval "$$(make aws-assume-role-export-variables)"
	make k8s-kubeconfig-get
	eval "$$(make k8s-kubeconfig-export)"
	eval "$$(make project-populate-secret-variables)"
	make k8s-deploy STACK=application
	echo "The URL is $(UI_URL)"

project-populate-secret-variables:
	echo "export API_DB_PASSWORD=$$(make -s aws-secret-get NAME=capacity-status-api-dev-api-db-password)"
	echo "export DOS_DB_PASSWORD=$$(make -s aws-secret-get NAME=capacity-status-api-dev-dos-db-dos-password)"
	echo "export APP_ADMIN_PASSWORD=$$(make -s aws-secret-get NAME=capacity-status-api-admin-password)"

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
		NAME=certificate \
		DOMAINS='localhost,DNS:*.k8s-prod.texasplatform.uk,DNS:*.k8s-nonprod.texasplatform.uk,DNS:proxy:443'

project-trust-certificates: ## Trust the development certificates
	sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain \
		$(PROJECT_DIR)/certificate/$(SSL_CERTIFICATE_NAME).pem

# ==============================================================================

project-verify-email:
	# TODO: The `AWS_ACCOUNT_ID_LIVE_PARENT` variables has to be set in Jenkins
	AWS_ACCOUNT_ID_LIVE_PARENT=462131752500
	if [ false == $$(make aws-account-check-id ID=$$AWS_ACCOUNT_ID_LIVE_PARENT) ]; then
		echo "ERROR: You are not logged into the live parent account"
		exit 1
	fi
	make aws-ses-verify-email-identity EMAIL=$(EMAIL_FROM)

# ==============================================================================

.SILENT: \
	project-populate-application-variables \
	project-populate-db-pu-job-variables


project-trust-certificate:
	make ssl-trust-certificate \
		FILE=$(PROJECT_DIR)/certificate/localhost.pem

# ==============================================================================

.SILENT:
