####################################################################################
# !!!!!!P R O D!!!!!!!!!
####################################################################################

####################################################################################
# TERRAFORM PLATFORM INFRASTRUCTURE COMMON
####################################################################################
terraform_platform_state_s3_bucket = "nhsd-texasplatform-terraform-state-store-lk8s-prod"

####################################################################################
# AWS COMMON
####################################################################################
aws_profile    = "nhsd-ddc-exeter-texas-live-k8s-prod"
aws_region     = "eu-west-2"
cloud_env_type = "prod"
profile        = "demo"

####################################################################################
# TEXAS COMMON
####################################################################################
billing_code_tag   = "k8s-prod.texasplatform.uk"
environment_tag    = "lk8s-prod.texasplatform.uk"
nhs_programme_name = "uec-dos-api-cs"
nhs_project_name   = "uec-dos-api-cs"
service_name       = "uec-dos-api-cs"
service_prefix     = "uec-dos-api-cs"

####################################################################################
# SERVICE COMMON
####################################################################################
version_tag = "0.1"

###################################################################################
# SECURITY GROUPS
####################################################################################
security-groups-k8s_terraform_state_key = "security-groups-k8s/terraform.tfstate"

####################################################################################
# VPC
####################################################################################
vpc_terraform_state_key = "vpc/terraform.tfstate"

####################################################################################
# SERVICE RDS POSTGRES
####################################################################################
db_identifier                 = "uec-dos-api-cs-demo"
db_name                       = "postgres"
db_master_username            = "postgres"
db_size                       = "db.t3.micro"
db_engine_version             = "11.6"
db_max_connections            = "100"
db_engine                     = "postgres"
db_storage                    = "gp2"
db_port                       = "5432"
db_subnet_group_name          = "uec-dos-api-cs-demo"
db_allocated_storage          = 5
enable_backup                 = true
backup_retention_period       = "4"
backup_window                 = "01:00-02:00"
maintenance_window            = "Tue:02:30-Tue:03:30"
deletion_protection           = false
db_auto_minor_version_upgrade = false
multi_az                      = false
skip_final_snapshot           = false
