# Data lookup from eks management terraform state
data "terraform_remote_state" "eks-mgmt" {
  backend = "s3"

  config = {
    bucket = var.terraform_platform_state_store
    key    = var.eks_mgmt_terraform_state_key
    region = var.aws_region
  }
}

# IAM role for service account
resource "aws_iam_role" "iam_service_account_role" {
  path = "/"
  name = var.service_account_role

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.aws_account_id}:oidc-provider/${trimprefix(data.terraform_remote_state.eks-mgmt.outputs.eks_oidc_issuer_url, "https://")}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${trimprefix(data.terraform_remote_state.eks-mgmt.outputs.eks_oidc_issuer_url, "https://")}:sub": "system.serviceaccount:${var.service_prefix}*:${var.service_account_name}"
        }
      }
    }
  ]
}
EOF

tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Programme   = var.nhs_programme_name
    Project     = var.nhs_project_name
    Terraform   = "true"
    Service     = var.service_name
  }

}

# Policies to add to the service account role
resource "aws_iam_role_policy_attachment" "rds_read_only_policy" {
  role       = aws_iam_role.iam_service_account_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}
