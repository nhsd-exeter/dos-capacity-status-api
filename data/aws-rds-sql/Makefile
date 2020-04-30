PROJECT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))/../..))
include $(abspath $(lastword $(MAKEFILE_LIST))/../../../build/automation/init.mk)

# ==============================================================================

build:
	cp -fv \
		$(DATA_DIR)/aws-rds-sql/*.sql \
		$(DOCKER_DIR)/data/assets/sql
	make docker-build NAME=data

run:
	make docker-image-start NAME=data	CMD="scripts /sql" \
    DB_HOST=$(or $(DB_HOST), $(DOS_DB_HOST)) \
    DB_PORT=$(or $(DB_PORT), $(DOS_DB_PORT)) \
    DB_NAME=$(or $(DB_NAME), $(DOS_DB_NAME)) \
    DB_USERNAME=$(or $(DB_USERNAME), $(DOS_DB_USERNAME)) \
    DB_PASSWORD=$(or $(DB_PASSWORD), $(DOS_DB_PASSWORD))

clean:
	rm -rf $(DOCKER_DIR)/data/assets/sql/*.sql
	make docker-image-clean NAME=data
