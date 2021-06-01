data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.terraform_platform_state_store
    key    = var.vpc_terraform_state_key
    region = var.aws_region
  }
}

data "terraform_remote_state" "security-groups-k8s" {
  backend = "s3"

  config = {
    bucket = var.terraform_platform_state_store
    key    = var.security_groups_k8s_terraform_state_key
    region = var.aws_region
  }
}

data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config = {
    bucket = var.terraform_platform_state_store
    key    = var.security_groups_terraform_state_key
    region = var.aws_region
  }
}

resource "aws_security_group" "rds_postgres_sg" {
  name        = "${var.service_prefix}-sg"
  description = "Allow connection by appointed rds postgres clients"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = {
    Name        = "Security Group for access to RDS Postgres"
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Programme   = var.nhs_programme_name
    Project     = var.nhs_project_name
    Terraform   = "true"
    Service     = var.service_name
  }
}

# INGRESS TO RDS POSTGRES FROM EKS #
resource "aws_security_group_rule" "rds_postgres_ingress_from_eks_worker" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_postgres_sg.id
  source_security_group_id = data.terraform_remote_state.security-groups-k8s.outputs.eks_worker_additional_sg_id
  description              = "Allow access in from Eks-worker to rds postgres"
}

# INGRESS TO RDS FROM VPN only if allowed (for nonprod)
resource "aws_security_group_rule" "allow_in_from_vpn" {
  count = var.cloud_env_type == "nonprod" ? 1 : 0

  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_postgres_sg.id
  source_security_group_id = data.terraform_remote_state.security-groups.outputs.vpn_main_sg_id
  description              = "Allow access in from VPN to rds postgres"
}
