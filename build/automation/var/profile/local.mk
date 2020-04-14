-include $(VAR_DIR)/platform-texas/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_HOST = api

API_DB_HOST = db-dos
API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
API_LOG_LEVEL = DEBUG

DOS_DB_HOST = db-dos
DOS_DB_NAME = postgres
DOS_DB_PORT = 5432
DOS_DB_USERNAME = postgres

APP_ADMIN_PASSWORD = admin

# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = http

# TODO: This has to go
API_IMAGE_TAG = 0.0.1
PROXY_IMAGE_TAG = 0.0.1
