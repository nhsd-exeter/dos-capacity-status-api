resource "aws_secretsmanager_secret" "capacity_status_db_password" {
  name                    = "${var.service_prefix}-db-password"
  description             = "Password for the master Postgres DB user"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "capacity_status_db_password" {
  secret_id     = aws_secretsmanager_secret.capacity_status_db_password.id
  secret_string = random_password.capacity_status_db_password.result
}

resource "random_password" "capacity_status_db_password" {
  length      = 16
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
