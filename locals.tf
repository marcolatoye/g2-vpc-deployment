locals {
  current_account_info = data.aws_caller_identity.current_account.account_id
  name_acc_prefix      = local.current_account_info == var.dev_account_num ? "dev" : "un-declared-account"
  region               = "us-east-1"

  vpc_tags = {
    Name       = "main-vpc"
    OwnerEmail = "marc.olatoye@gmail.com"
    Schedule   = "A"
    Backup     = "Yes"
  }
}


locals {
  wp_creds = jsondecode(
    data.aws_secretsmanager_secret_version.wpcreds.secret_string
  )

  # depends_on = [
  #   aws_secretsmanager_secret_version.wpcreds
  # ]
}
