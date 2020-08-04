PROGRAMME = uec
PROJECT_GROUP = uec/dos-api
PROJECT_GROUP_SHORT = uec-dos-api
PROJECT_NAME = capacity-status
PROJECT_NAME_SHORT = cs

ROLE_PREFIX = UECDoSAPI
SERVICE_TAG = $(PROJECT_GROUP_SHORT)
PROJECT_TAG = $(PROJECT_NAME)

# ==============================================================================
# Business rules

SERVICE_RESET_STATUS_IN_DEFAULT_MINS = 240
SERVICE_RESET_STATUS_IN_MINIMUM_MINS = 0
SERVICE_RESET_STATUS_IN_MAX_MINS = 7200

# ==============================================================================

PYTHON_VERSION = 3.8.2
DOCKER_PYTHON_VERSION = $(PYTHON_VERSION)-slim
