-include $(VAR_DIR)/platform-texas/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_HOST = uec-dos-api-cs
#API_ADMIN_ALLOWED_HOSTS = [secret]

#API_DB_HOST = [secret]
API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
#API_DB_PASSWORD = [secret]
API_LOG_LEVEL = INFO

#DOS_DB_HOST = [secret]
DOS_DB_NAME = pathwaysdos
DOS_DB_PORT = 5432
DOS_DB_USERNAME = postgres
#DOS_DB_PASSWORD = [secret]

#APP_ADMIN_PASSWORD = [secret]

# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = https
REQUEST_ID_HEADER = HTTP_X_REQUEST_ID

# TODO: This has to go
API_IMAGE_TAG = 0.1.0
PROXY_IMAGE_TAG = 0.1.0

# ==============================================================================
# Infrastructure variables

STACKS = service

TF_VAR_profile = $(PROFILE)
