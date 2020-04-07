resource "aws_secretsmanager_secret" "postgres_capacity_status_api_master_password" {
  name                    = "${var.service_prefix}-${var.cloud_env_type}-postgres_capacity_status_api_password"
  description             = "Password for the master Postgres DB user"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "postgres_capacity_status_api_master_password" {
  secret_id     = aws_secretsmanager_secret.postgres_capacity_status_api_master_password.id
  secret_string = random_password.postgres_capacity_status_api_master_password.result
}

resource "random_password" "postgres_capacity_status_api_master_password" {
  length      = 16
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}

