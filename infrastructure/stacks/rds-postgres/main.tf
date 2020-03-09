
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.terraform_platform_state_s3_bucket}"
    key    = "${var.vpc_terraform_state_key}"
    region = "${var.aws_region}"
  }
}

data "terraform_remote_state" "security-groups-k8s" {
  backend = "s3"

  config = {
    bucket = "${var.terraform_platform_state_s3_bucket}"
    key    = "${var.security-groups-k8s_terraform_state_key}"
    region = "${var.aws_region}"
  }
}

##################
#  Parameter Group
##################
resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.service_prefix}-pg"
  family = "postgres11"

  parameter {
    name         = "max_connections"
    value        = "${var.db_max_connections}"
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
    apply_method = "pending-reboot"
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
    apply_method = "pending-reboot"
  }
}


#####
# DB
#####
resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.db_subnet_group_name}"
  #subnet_ids = ["${data.terraform_remote_state.vpc.private_subnets.0}", "${data.terraform_remote_state.vpc.private_subnets.1}",  "${data.terraform_remote_state.vpc.private_subnets.2}"]
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  tags = {
    Name        = "${var.service_prefix}-${var.db_identifier}"
    BillingCode = "${var.billing_code_tag}"
    Environment = "${var.environment_tag}"
    Version     = "${var.version_tag}"
    Service     = "${var.service_name}"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier           = "${var.db_identifier}"
  engine               = "${var.db_engine}"
  engine_version       = "${var.db_engine_version}"
  instance_class       = "${var.db_size}"
  allocated_storage    = "${var.allocated_storage}"
  storage_encrypted    = "${var.db_storage_encryption}"
  storage_type         = "${var.db_storage}"
  multi_az             = "${var.multi_az}"
  parameter_group_name = "${aws_db_parameter_group.parameter_group.name}"
  name                 = "${var.db_name}"
  username             = "${var.db_master_username}"
  password             = "${var.db_master_password}"
  port                 = "${var.db_port}"
  # TODO agree on where SGs for other AWS resources are created with regards to egress / ingress (e.g. out from worker / in on rds)
  vpc_security_group_ids = ["${aws_security_group.rds-postgres-sg.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.db_subnet_group.name}"

  maintenance_window      = "${var.maintenance_window}"
  backup_window           = "${var.backup_window}"
  backup_retention_period = "${var.backup_retention_period}"

  final_snapshot_identifier  = "${var.db_identifier}-final"
  publicly_accessible        = "${var.publicly_accessible}"
  auto_minor_version_upgrade = "${var.db_auto_minor_version_upgrade}"
  copy_tags_to_snapshot      = "${var.db_copy_tags_to_snapshot}"
  apply_immediately          = "${var.apply_immediately}"

  tags = {
    Name        = "${var.service_prefix}-${var.db_identifier}"
    BillingCode = "${var.billing_code_tag}"
    Environment = "${var.environment_tag}"
    Version     = "${var.version_tag}"
    Programme   = "${var.nhs_programme_name}"
    Project     = "${var.nhs_project_name}"
    Terraform   = "true"
    Service     = "${var.service_name}"
  }
}

resource "aws_security_group" "rds-postgres-sg" {
  name        = "${var.service_prefix}-${var.db_sg_name_suffix}"
  description = "Allow connection by appointed rds postgres clients"
  vpc_id      = "${data.terraform_remote_state.vpc.outputs.vpc_id}"

  tags = {
    Name        = "Security Group for access to RDS Postgres"
    BillingCode = "${var.billing_code_tag}"
    Environment = "${var.environment_tag}"
    Version     = "${var.version_tag}"
    Programme   = "${var.nhs_programme_name}"
    Project     = "${var.nhs_project_name}"
    Terraform   = "true"
    Service     = "${var.service_name}"
  }
}

# INGRESS TO RDS POSTGRES FROM EKS #
resource "aws_security_group_rule" "rds_postgres_ingress_from_eks_worker" {
  type                     = "ingress"
  from_port                = "${var.db_port}"
  to_port                  = "${var.db_port}"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.rds-postgres-sg.id}"
  source_security_group_id = "${data.terraform_remote_state.security-groups-k8s.outputs.eks_worker_additional_sg_id}"
  description              = "Allow access in from Eks-worker to rds postgres"
}
