AWS_ACCOUNT_ID := $(AWS_ACCOUNT_ID_NONPROD)
AWS_ACCOUNT_NAME := nonprod
AWS_CERTIFICATE = c0718115-4e22-4f48-a4aa-8c16ea86c5e6
TF_VAR_terraform_platform_state_store = nhsd-texasplatform-terraform-state-store-live-lk8s-$(AWS_ACCOUNT_NAME)

# ==============================================================================

include $(VAR_DIR)/platform-texas/platform-texas-v1.mk
