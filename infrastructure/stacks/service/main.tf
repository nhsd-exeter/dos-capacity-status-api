module "rds" {
  source                  = "../../modules/rds"
  service_prefix          = var.service_prefix
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  db_size                 = var.db_size
  multi_az                = var.multi_az
  skip_final_snapshot     = var.skip_final_snapshot
  db_master_username      = var.db_master_username
  db_name                 = var.db_name
  private_subnets_ids     = data.terraform_remote_state.vpc.outputs.private_subnets


  db_allocated_storage          = var.db_allocated_storage
  apply_immediately             = var.apply_immediately
  backup_window                 = var.backup_window
  maintenance_window            = var.maintenance_window
  db_storage                    = var.db_storage
  db_engine                     = var.db_engine
  db_engine_version             = var.db_engine_version
  cloud_env_type                = var.cloud_env_type
  profile                       = var.profile
  db_port                       = var.db_port
  db_auto_minor_version_upgrade = var.db_auto_minor_version_upgrade

  billing_code_tag   = var.billing_code_tag
  environment_tag    = var.environment_tag
  version_tag        = var.version_tag
  nhs_programme_name = var.nhs_programme_name
  nhs_project_name   = var.nhs_project_name
  service_name       = var.service_name

  db_max_connections                      = var.db_max_connections
  security_groups_k8s_terraform_state_key = var.security_groups_k8s_terraform_state_key
  db_subnet_group_name                    = var.db_subnet_group_name

  terraform_platform_state_store = var.terraform_platform_state_store
  vpc_terraform_state_key        = var.vpc_terraform_state_key
  aws_region                     = var.aws_region
}
