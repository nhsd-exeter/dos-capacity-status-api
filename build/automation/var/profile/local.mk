-include $(VAR_DIR)/platform-texas/v1/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

API_HOST = api
API_ADMIN_ALLOWED_HOSTS = 127.0.0.1,localhost,cs.local
API_ADMIN_PASSWORD = admin

API_DB_HOST = db.$(PROJECT_NAME_SHORT).local
API_DB_NAME = capacity_status
API_DB_PORT = 5432
API_DB_USERNAME = postgres
API_DB_PASSWORD = postgres
API_DEBUG = False
API_LOG_LEVEL = DEBUG

DB_DOS_HOST = db.$(PROJECT_NAME_SHORT).local
DB_DOS_NAME = postgres
DB_DOS_PORT = 5432
DB_DOS_USERNAME = API_DB_USERNAME
DB_DOS_PASSWORD = API_DB_PASSWORD


# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = https
REQUEST_ID_HEADER =
