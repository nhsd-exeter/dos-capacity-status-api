-include $(VAR_DIR)/platform-texas/account-live-k8s-prod.mk

# ==============================================================================
# Service variables

API_HOST = uec-dos-api-cs
#API_ADMIN_ALLOWED_HOSTS = [secret]
#API_ADMIN_PASSWORD = [secret]

#API_DB_HOST = [secret]
API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
#API_DB_PASSWORD = [secret]
API_DEBUG = False
API_LOG_LEVEL = INFO

#DB_DOS_HOST = [secret]
DB_DOS_NAME = pathwaysdos_ut # postgres
DB_DOS_PORT = 5432
DB_DOS_USERNAME = release_manager # capacity_status_api
#DB_DOS_PASSWORD = [secret]


# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = https
REQUEST_ID_HEADER = HTTP_X_REQUEST_ID

# ==============================================================================
# Infrastructure variables

STACKS = service

TF_VAR_profile = $(PROFILE)
