resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.private_subnets_ids
  tags = {
    Name        = "${var.service_prefix}-${var.profile}"
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }
}

resource "aws_db_instance" "db_instance" {
  allocated_storage         = var.db_allocated_storage
  apply_immediately         = var.apply_immediately
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  deletion_protection       = var.deletion_protection #TODO check : added based off looking at SF
  publicly_accessible       = false
  storage_encrypted         = true
  storage_type              = var.db_storage
  engine                    = var.db_engine
  engine_version            = var.db_engine_version
  instance_class            = var.db_size
  identifier                = "${var.service_prefix}-${var.profile}"
  name                      = var.db_name
  final_snapshot_identifier = "${var.service_prefix}-${var.profile}-final-snapshot"
  skip_final_snapshot       = var.skip_final_snapshot #TODO check : added based off looking at SF
  copy_tags_to_snapshot     = true
  username                  = var.db_master_username
  password                  = aws_secretsmanager_secret_version.capacity_status_db_password.secret_string
  db_subnet_group_name      = aws_db_subnet_group.db_subnet_group.name
  multi_az                  = var.multi_az
  parameter_group_name      = aws_db_parameter_group.parameter_group.name
  # TODO agree on where SGs for other AWS resources are created with regards to egress / ingress (e.g. out from worker / in on rds)
  vpc_security_group_ids     = [aws_security_group.rds-postgres-sg.id]
  port                       = var.db_port                       #TODO check this is needed not in SF setup
  auto_minor_version_upgrade = var.db_auto_minor_version_upgrade #TODO check this is needed not in SF setup

  tags = {
    Name        = "${var.service_prefix}-${var.profile}"
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Programme   = var.nhs_programme_name
    Project     = var.nhs_project_name
    Terraform   = "true"
    Service     = var.service_name
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.service_prefix}-pg"
  family = "postgres11"

  parameter {
    name         = "max_connections"
    value        = var.db_max_connections
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "client_encoding"
    value        = "UTF8"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "immediate"
  }
  parameter {
    name         = "timezone"
    value        = "GB"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "rds.log_retention_period"
    value        = "5760"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "ssl"
    value        = "1"
    apply_method = "immediate"
  }
}
