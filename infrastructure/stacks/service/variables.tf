
##################################################################################
# INFRASTRUCTURE COMPONENT VERSION
##################################################################################
variable "version_tag" {
  description = "The infrastructure component version assigned by Texas development. The version MUST be incremented when changed <major version>.<minor version>"
  default     = "1.0"
}

##################################################################################
# AWS COMMON
##################################################################################
variable "aws_region" {
  description = "The AWS region"
}
variable "aws_profile" {
  description = "The AWS profile"
}
variable "aws_account_id" {
  description = "The identifier of the AWS Account"
}
variable "cloud_env_type" {
  description = "The cloud enviroment type e.g. nonprod, prod"
}
variable "profile" {
  description = "The profile for the deployment e.g. dev, demo, live"
}

############################
# TERRAFORM COMMON
############################
variable "terraform_platform_state_store" {
  description = "Name of the S3 bucket used to store the Terraform state"
}

variable "vpc_terraform_state_key" {
  description = "The VPC key in the terraform state bucket"
}

variable "route53_terraform_state_key" {
  description = "The Route 53 key in the terraform state bucket"
}

variable "eks_mgmt_terraform_state_key" {
  description = "The EKS management terraform state key"
}

####################################################################################
# TEXAS COMMON
####################################################################################
variable "billing_code_tag" {
  description = "The tag used to identify component for billing purposes"
}

variable "environment_tag" {
  description = "The tag used to identify component environment"
}

variable "service_prefix" {
  description = "Prefix used for naming resources"
}
variable "security_groups_terraform_state_key" {
  description = "The security-groups key in the terraform state bucket"
}
variable "security_groups_k8s_terraform_state_key" {
  description = "The security-groups-k8s key in the terraform state bucket"
}
variable "nhs_programme_name" {
  description = "The NHS Programme using the resource"
}

variable "nhs_project_name" {
  description = "The NHS Project using the resource"
}

variable "service_name" {
  description = "The tag used to identify the service the resource belongs to"
}

############################
# RDS DATABASE
############################
# The following variables are all read from the variables-<environment>.tfvars.json file
variable "db_identifier" {}
variable "db_name" {}
variable "db_master_username" {}
variable "db_size" {}
variable "db_engine_version" {}
variable "db_engine" {}
variable "db_storage" {}
variable "db_dns_name" {}

variable "db_port" {}
variable "db_allocated_storage" {}
variable "enable_backup" {
  default = false
}
variable "backup_retention_period" {}
variable "backup_window" {}
# Maintenance window should be after backup and within allowed times for region:
#(see https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#AdjustingTheMaintenanceWindow
variable "maintenance_window" {}
variable "db_auto_minor_version_upgrade" {}
variable "multi_az" {}
variable "db_subnet_group_name" {}
variable "db_max_connections" {}
variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  default     = false
}
variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true."
}

variable "skip_final_snapshot" {}


############################
# IAM Service Account Role
############################
variable "service_account_role" {
  description = "The name of the service account IAM role."
}
variable "service_account_name" {
  description = "The name of the K8s service account that the service IAM Role will be associated with."
}
