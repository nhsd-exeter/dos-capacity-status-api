-include $(VAR_DIR)/platform-texas/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_HOST = uec-dos-api-cs

API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
API_LOG_LEVEL = INFO

DOS_DB_NAME = pathwaysdos_test
DOS_DB_PORT = 5432
DOS_DB_USERNAME = postgres

# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = https

# TODO: This has to go
API_IMAGE_TAG = 0.0.1
PROXY_IMAGE_TAG = 0.0.1

# ==============================================================================
# Infrastructure variables

STACKS = service

TF_VAR_profile = $(PROFILE)
