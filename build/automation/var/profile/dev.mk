-include $(VAR_DIR)/platform-texas/v1/account-live-k8s-nonprod.mk

# ==============================================================================
# Service variables

PROJECT_IMAGE_TAG =
ENV = dev
SERVICE_PREFIX = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)-$(ENVIRONMENT)
DEPLOYMENT_SECRETS = $(PROJECT_ID)/deployment

K8S_TTL_LENGTH = 2 days
API_HOST = uec-dos-api-cs
# Please see ADR-009
REQ_PER_SEC_PROXY_THROTTLE = 3
#API_ADMIN_ALLOWED_HOSTS = [secret]
#API_ADMIN_PASSWORD = [secret]

API_DB_HOST = $(SERVICE_PREFIX).db.$(TF_VAR_platform_zone)
API_DB_NAME = postgres
API_DB_PORT = 5432
API_DB_USERNAME = postgres
#API_DB_PASSWORD = [secret]
API_DEBUG = True
API_LOG_LEVEL = INFO
SPLUNK_INDEX = eks_logs_uec_dos_api_cs_nonprod

API_DB_PASSWORD_STORE = $(SERVICE_PREFIX)-db-password
API_PASSWORD_STORE = $(SERVICE_PREFIX)-api-admin-password
DJANGO_SECRET_STORE = $(SERVICE_PREFIX)-django-secret

#DB_DOS_HOST = [secret]
DB_DOS_NAME = postgres
DB_DOS_PORT = 5432
DB_DOS_USERNAME = capacity_status_api
#DB_DOS_PASSWORD = [secret]

# TODO: What is this variable for? We always should be using https
HTTP_PROTOCOL = https
REQUEST_ID_HEADER = HTTP_X_REQUEST_ID

#CS_API_SG = [secret]
# ==============================================================================
# Infrastructure variables

STACKS = service

TF_VAR_profile = $(PROFILE)
TF_VAR_aws_region = $(AWS_REGION)
TF_VAR_cloud_env_type = $(AWS_ACCOUNT_NAME)
TF_VAR_billing_code_tag = $(TF_VAR_platform_zone)
TF_VAR_environment_tag = lk8s-nonprod.texasplatform.uk
TF_VAR_nhs_programme_name = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)
TF_VAR_nhs_project_name = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)
TF_VAR_service_name = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)
TF_VAR_service_prefix = $(SERVICE_PREFIX)
TF_VAR_version_tag = 0.1
TF_VAR_db_identifier = $(SERVICE_PREFIX)
TF_VAR_db_dns_name = $(SERVICE_PREFIX).db.$(TF_VAR_platform_zone)
TF_VAR_db_name = $(API_DB_NAME)
TF_VAR_db_master_username = $(API_DB_USERNAME)
TF_VAR_db_size = db.t3.micro
TF_VAR_db_engine_version = 11.6
TF_VAR_db_max_connections = 100
TF_VAR_db_engine = postgres
TF_VAR_db_storage = gp2
TF_VAR_db_port = $(API_DB_PORT)
TF_VAR_db_subnet_group_name = $(SERVICE_PREFIX)
TF_VAR_db_allocated_storage = 5
TF_VAR_enable_backup = true
TF_VAR_backup_retention_period = 4
TF_VAR_backup_window = 01:00-02:00
TF_VAR_maintenance_window = tue:02:30-tue:03:30
TF_VAR_deletion_protection = false
TF_VAR_db_auto_minor_version_upgrade = false
TF_VAR_multi_az = false
TF_VAR_skip_final_snapshot = false
