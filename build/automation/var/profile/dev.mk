-include $(VAR_DIR)/platform-texas/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_DB_HOST := uec-dos-api-cs-nonprod-db.cqger35bxcwy.eu-west-2.rds.amazonaws.com # TODO: Let's move it to the Secret Manager
API_DB_NAME := capacity_status
API_DB_PORT := 5432
API_DB_USERNAME := postgres
API_LOG_LEVEL := INFO

DOS_DB_HOST := uec-dos-api-cs-nonprod-db.cqger35bxcwy.eu-west-2.rds.amazonaws.com # TODO: Let's move it to the Secret Manager
DOS_DB_NAME := postgres
DOS_DB_PORT := 5432
DOS_DB_USERNAME := postgres

API_IMAGE_TAG := 0.0.1
PROXY_IMAGE_TAG := 0.0.1

# ==============================================================================
# Infrastructure variables

STACKS := application

TF_VAR_profile := $(PROFILE) # This evaluates to 'dev'
