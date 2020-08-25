-include $(VAR_DIR)/platform-texas/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_HOST = api
API_ADMIN_ALLOWED_HOSTS = 127.0.0.1,localhost,cs.local

API_DB_HOST = db.$(PROJECT_NAME_SHORT).local
API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
API_DB_PASSWORD = postgres
API_LOG_LEVEL = DEBUG

DB_DOS_HOST = db.$(PROJECT_NAME_SHORT).local
DB_DOS_NAME = postgres
DB_DOS_PORT = 5432
DB_DOS_USERNAME = $(API_DB_USERNAME)
DB_DOS_PASSWORD = $(API_DB_PASSWORD)

APP_ADMIN_PASSWORD = admin

# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = http
REQUEST_ID_HEADER =

# TODO: This has to go
API_IMAGE_TAG = 0.0.1
PROXY_IMAGE_TAG = 0.0.1
