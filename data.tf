data "aws_secretsmanager_secret_version" "wpcreds" {
  # Fill in the name you gave to your secret
  secret_id = var.aws_secrets_manid
}

# Call current profile account information
data "aws_caller_identity" "current_account" {}





