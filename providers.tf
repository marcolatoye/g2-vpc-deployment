provider "aws" {

  region = var.AWS_REGION
  # access_key = var.AWS_ACCESS_KEY
  # secret_key = var.AWS_SECRET_KEY
  #profile = var.aws_profile

  assume_role {
    # The role ARN within Dev Account to AssumeRole into. Created in step 1.
    role_arn = var.engineer_role_arn

  }

}

