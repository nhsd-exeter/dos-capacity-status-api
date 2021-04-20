resource "aws_secretsmanager_secret" "api_admin_password" {
  name                    = "${var.service_prefix}-api-admin-password"
  description             = "Password for the Admin API user"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_admin_password" {
  secret_id     = aws_secretsmanager_secret.api_admin_password.id
  secret_string = random_password.api_admin_password.result
}

resource "random_password" "api_admin_password" {
  length      = 16
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}

resource "aws_secretsmanager_secret" "django_secret" {
  name                    = "${var.service_prefix}-django-secret"
  description             = "Django Application Secret Key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "django_secret" {
  secret_id     = aws_secretsmanager_secret.django_secret.id
  secret_string = random_password.django_secret.result
}

resource "random_password" "django_secret" {
  length      = 16
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  special     = false
}
