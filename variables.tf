# Input Variables
# AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1"
}

variable "AWS_REGION" {
  default = "us-east-1"
}

# variable "AWS_ACCESS_KEY" {}
# variable "AWS_SECRET_KEY" {}

variable "engineer_role_arn" {
  default = "arn:aws:iam::142772877088:role/Engineer"
}

variable "dev_account_num" {
  default = 142772877088
}


variable "ami" {
  default = "ami-08f3d892de259504d" #AMI for ECS ami-0ac7415dd546fb485
}

variable "ami_appserver" {
  default = "ami-007855ac798b5175e"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "db_instance_type" {
  default = "db.t3.micro"
  type    = string
}


variable "dev_names" {

  default = ["sdf", "sdh", "sdg", "sdi", "sdj"]
}


variable "dev_nam" {
  default = ["/dev/sdf", "/dev/sdg", "/dev/sdh", "/dev/sdi", "/dev/sdj"]
}


variable "volume_size" {
  default = 10
}

variable "counter" {
  default = 5
}

variable "mount_point" {
  default = "/var/www/html"
}


variable "aws_secrets_manid" {
  default = "g2secrets"
}

variable "rdsport" {
  default = 5432
}

variable "rails_appname" {
  default = "rails_neu"
}

variable "asdfbin" {
  default = "/root/.asdf/bin"
}

variable "asdf_rubybin" {
  default = "/root/.asdf/installs/ruby/3.2.2/bin"
}

variable "backend_bucket" {
  default = "marcusrubybucket"
}

variable "backet_dynamodb" {
  default = "G2-RubyRails-StateLocking"
}

variable "roothome" {
  default = "/root"
}

variable "useremail" {
  default = "marc.olatoye@gmail.com"
}

variable "environment" {
  type = map(string)
  default = {
    142772877088 = "dev"
    838518434784 = "uat"
    123456789012 = "prod"
    908765432123 = "mgmt"
  }
}
