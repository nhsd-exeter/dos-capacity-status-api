PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))/../..))
include $(abspath $(lastword $(MAKEFILE_LIST))/../../../build/automation/init.mk)

# ==============================================================================

build:
	cp -fv \
		$(DATA_DIR)/aws-rds-sql/*.sql \
		$(DOCKER_DIR)/data/assets/data
	make file-replace-variables-in-dir DIR=$(DOCKER_DIR)/data/assets/data
	make docker-build NAME=data VERSION=$(VERSION)

run:
	make docker-image-start NAME=data	CMD="scripts /data" \
		DB_HOST=$(or $(DB_HOST), $(DB_DOS_HOST)) \
		DB_PORT=$(or $(DB_PORT), $(DB_DOS_PORT)) \
		DB_NAME=$(or $(DB_NAME), $(DB_DOS_NAME)) \
		DB_USERNAME=$(or $(DB_USERNAME), $(DB_DOS_USERNAME)) \
		DB_PASSWORD=$(or $(DB_PASSWORD), $(DB_DOS_PASSWORD))

clean:
	rm -rf $(DOCKER_DIR)/data/assets/data/*.sql
	make docker-image-clean NAME=data
