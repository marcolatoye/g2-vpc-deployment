#########################################################################
############################ RDS Instance ###############################

resource "aws_db_instance" "database-instance" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "14.6"
  instance_class    = var.db_instance_type
  identifier        = local.wp_creds.rds_dbname
  username          = local.wp_creds.rds_user_name
  password          = local.wp_creds.rds_pass_word
  #parameter_group_name = "default.postgres12"
  vpc_security_group_ids = [aws_security_group.rds-instance-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  skip_final_snapshot    = true

  # Enable Multi-AZ deployment
  multi_az = true

  # Enable automated backups
  backup_retention_period = 7
  backup_window           = "00:00-00:30"

  # Enable Enhanced Monitoring
  monitoring_interval = 0

  # Enable Performance Insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
}

# resource "aws_db_instance" "database-instance" {
#   identifier             = local.wp_creds.database-instance-identifier
#   instance_class         = var.db_instance_type
#   snapshot_identifier    = data.aws_db_snapshot.database_snapshot.id
#   vpc_security_group_ids = [aws_security_group.rds-instance-sg.id]
#   db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
#   skip_final_snapshot    = true
# }

# data "aws_db_snapshot" "database_snapshot" {
#   db_snapshot_identifier = local.wp_creds.db_snapshot_identifier
#   most_recent            = true
#   snapshot_type          = "manual"
# }

resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "rds_subnet_group"
  subnet_ids  = [aws_subnet.rds_private_az1.id, aws_subnet.rds_private_az2.id]
  description = "RDS Subnet Group"
}


output "new_host" {
  value = aws_db_instance.database-instance.endpoint
}
