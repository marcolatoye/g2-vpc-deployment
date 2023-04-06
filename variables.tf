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


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}


variable "engineer_role_arn" {}

variable "dev_account_num" {}


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

variable "ecr_repo_name" {
  default = "clixx-repository"
}
variable "proj_name" {
  type        = string
  default     = "clixx-webapp"
  description = "Project Name"
}

variable "work_environment" {
  type        = string
  description = "SDLC Environment"
  default     = "development"
}

variable "aws_secrets_manid" {}

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

# variable "mount_point" {
#   default = "/var/www/html"
# }