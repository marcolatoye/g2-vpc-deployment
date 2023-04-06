### Key Pair
resource "aws_key_pair" "pubsub-key-pair" {
  key_name   = "pubsub-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pubsub-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "pubsub-key-pair"
}


# Bastion server launch template in the public subnet
resource "aws_launch_template" "bastion_server_template" {
  name          = "bastion-az1-${local.name_acc_prefix}"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "pubsub-key-pair"
  user_data = "${base64encode(<<EOF
        ${templatefile("${path.module}/bastionserver_btstrp.sh", { MOUNT_POINT=var.mount_point, DD_KEY = "${local.wp_creds.datadog_key}" })}
        EOF
)}"


#base64encode(file("${path.module}/bastionserver_btstrp.sh"))

network_interfaces {
  associate_public_ip_address = true
  device_index                = 0
  security_groups             = [aws_security_group.bastion-server-sg.id]
}


tags = {
  Name       = "bastion-server"
  OwnerEmail = "marc.olatoye@gmail.com"
  Backup     = "Yes"
}

dynamic "block_device_mappings" {
  for_each = [for vol in var.dev_names : {
    device_name           = "/dev/${vol}"
    virtual_name          = "ebs_dsk-${vol}"
    delete_on_termination = true
    encrypted             = false
    volume_size           = 10
    volume_type           = "gp2"
  }]
  content {
    device_name  = block_device_mappings.value.device_name
    virtual_name = block_device_mappings.value.virtual_name

    ebs {
      delete_on_termination = block_device_mappings.value.delete_on_termination
      encrypted             = block_device_mappings.value.encrypted
      volume_size           = block_device_mappings.value.volume_size
      volume_type           = block_device_mappings.value.volume_type
    }
  }

}

}


###########################################################################################
###########################################################################################

############################################################################
############################# Creating app servers #########################
### Key Pair
resource "aws_key_pair" "privsub-key-pair" {
  key_name   = "privsub-key-pair"
  public_key = tls_private_key.rsa2.public_key_openssh
}

resource "tls_private_key" "rsa2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "privsub-key" {
  content  = tls_private_key.rsa2.private_key_pem
  filename = "privsub-key-pair"
}


resource "aws_launch_template" "app_server_template" {
  name                   = "app_server"
  vpc_security_group_ids = [aws_security_group.server-lt-sg.id]
  image_id               = var.ami_appserver
  instance_type          = var.instance_type
  key_name               = "privsub-key-pair"

  user_data = "${base64encode(<<EOF
        ${templatefile("${path.module}/rail_application_btstrp.sh",
    { rds_username = "${local.wp_creds.rds_user_name}",
      rds_password = "${local.wp_creds.rds_pass_word}", region = "${local.wp_creds.aws_region}",
      rds_hostname = element(split(":", aws_db_instance.database-instance.endpoint), 0),
      efs_dnsname  = aws_efs_file_system.app-server-efs.dns_name, RAILS_APPNAME = var.rails_appname, DD_KEY = "${local.wp_creds.datadog_key}", rds_port = var.rdsport,
      asdf_bin     = var.asdfbin, asdf_ruby_bin = var.asdf_rubybin, HOME = var.roothome })}
        EOF
)}"



# dynamic "block_device_mappings" {
#   for_each = [for vol in var.dev_names : {
#     device_name           = "/dev/${vol}"
#     virtual_name          = "ebs_dsk-${vol}"
#     delete_on_termination = true
#     encrypted             = false
#     volume_size           = 10
#     volume_type           = "gp2"
#   }]
#   content {
#     device_name  = block_device_mappings.value.device_name
#     virtual_name = block_device_mappings.value.virtual_name

#     ebs {
#       delete_on_termination = block_device_mappings.value.delete_on_termination
#       encrypted             = block_device_mappings.value.encrypted
#       volume_size           = block_device_mappings.value.volume_size
#       volume_type           = block_device_mappings.value.volume_type
#     }
#   }

# }

}
