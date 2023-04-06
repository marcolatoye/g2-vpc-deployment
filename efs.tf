resource "aws_efs_file_system" "app-server-efs" {
  creation_token   = "my-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "false"
  tags = {
    Name = "clixx-terraform-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount_target-a" {
  file_system_id  = aws_efs_file_system.app-server-efs.id
  subnet_id       = aws_subnet.app_server_private_az1.id
  security_groups = [aws_security_group.efs-sg.id]
}

resource "aws_efs_mount_target" "efs_mount_target-b" {
  file_system_id  = aws_efs_file_system.app-server-efs.id
  subnet_id       = aws_subnet.app_server_private_az2.id
  security_groups = [aws_security_group.efs-sg.id]
}

# Output efs
output "efs_clixx_output2" {
  value = element(split(".", aws_efs_file_system.app-server-efs.dns_name), 0)
}

output "efs_clixx_dnsname" {
  value = aws_efs_file_system.app-server-efs.dns_name
}

# Output efs

output "efs_clixx_output" {
  value = aws_efs_file_system.app-server-efs.id
}
