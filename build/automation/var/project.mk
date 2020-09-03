PROGRAMME = uec
PROJECT_GROUP = uec/dos-api
PROJECT_GROUP_SHORT = uec-dos-api
PROJECT_NAME = capacity-status
PROJECT_NAME_SHORT = cs

ROLE_PREFIX = UECDoSAPI
SERVICE_TAG = $(PROJECT_GROUP_SHORT)
PROJECT_TAG = $(PROJECT_NAME)

TEXAS_ROLE_PREFIX = UECDoSAPI
TEXAS_SERVICE_TAG = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)
# TODO: Remove it once we migrate to the latestes (3rd Sep or newer) Make DevOps automation sctipts
TEXAS_TERRAFORM_VERSION = $(TERRAFORM_VERSION)

# ==============================================================================
# Business rules

SERVICE_RESET_STATUS_IN_DEFAULT_MINS = 240
SERVICE_RESET_STATUS_IN_MINIMUM_MINS = 0
SERVICE_RESET_STATUS_IN_MAX_MINS = 7200

# ==============================================================================

INSTANA_AGENT_PORT = 42699
AUTOWRAPT_BOOTSTRAP = instana
