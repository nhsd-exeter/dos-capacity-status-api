ORG_NAME = nhsd-exeter
PROGRAMME = uec
PROJECT_GROUP = uec/dos-api
PROJECT_GROUP_SHORT = uec-dos-api
PROJECT_NAME = capacity-status
PROJECT_NAME_SHORT = cs
PROJECT_DISPLAY_NAME = DoS Capacity Status API
PROJECT_ID = $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME_SHORT)

ROLE_PREFIX = UECDoSAPI
PROJECT_TAG = $(PROJECT_NAME)
SERVICE_TAG = $(PROJECT_GROUP_SHORT)
SERVICE_TAG_COMMON = texas

DOCKER_REPOSITORIES =
SSL_DOMAINS_PROD =

# ---

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
