####################################################################################
# !!!!!!N O N-P R O D!!!!!!!!!
####################################################################################

####################################################################################
# TERRAFORM PLATFORM INFRASTRUCTURE COMMON
####################################################################################
terraform_platform_state_s3_bucket = "nhsd-texasplatform-terraform-state-store-live-lk8s-nonprod"

####################################################################################
# AWS COMMON
####################################################################################
aws_profile = "nhsd-ddc-exeter-texas-live-k8s-nonprod"
aws_region  = "eu-west-2"


####################################################################################
# TEXAS COMMON
####################################################################################
billing_code_tag   = "k8s-nonprod.texasplatform.uk"
environment_tag    = "lk8s-nonprod.texasplatform.uk"
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
db_identifier                 = "uec-dos-api-cs-nonprod-db"
db_name                       = "postgres"
db_master_username            = "postgres"
db_size                       = "db.t3.micro"
db_engine_version             = "11.6"
db_max_connections            = "100"
db_engine                     = "postgres"
db_storage                    = "gp2"
db_port                       = "5432"
db_parameter_group_name       = "uec-dos-api-cs-nonprod-pg"
db_sg_name_suffix             = "uec-dos-api-cs-nonprod-db-sg"
db_subnet_group_name          = "uec-dos-api-cs-nonprod-db"
allocated_storage             = 1
enable_backup                 = true
backup_retention_period       = "4"
backup_window                 = "01:00-02:00"
maintenance_window            = "Tue:02:30-Tue:03:30"
publicly_accessible           = false
db_storage_encryption         = true
db_auto_minor_version_upgrade = false
db_copy_tags_to_snapshot      = true
multi_az                      = false
