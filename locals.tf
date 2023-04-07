locals {
  current_account_info = data.aws_caller_identity.current_account.account_id
  
  name_acc_prefix = try(
    lookup(
      {
        for k, v in var.environment : k => v
      },
      data.aws_caller_identity.current_account.account_id,
    ),
    null
  )
  region = "us-east-1"

}


locals {
  wp_creds = jsondecode(
    data.aws_secretsmanager_secret_version.wpcreds.secret_string
  )

  # depends_on = [
  #   aws_secretsmanager_secret_version.wpcreds
  # ]
}
