
terraform {
  backend "s3" {
    bucket         = "g2-vpc-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "g2-vpc-state-lock"
    encrypt        = true
    role_arn       = "arn:aws:iam::142772877088:role/Engineer"
  }
}

