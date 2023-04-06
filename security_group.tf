####    Security group to load balancer
resource "aws_security_group" "elb-sg" {
  vpc_id      = aws_vpc.main-vpc.id
  name        = "Loadbalancer-sg"
  description = "Load balancer security group"
}

resource "aws_security_group_rule" "elb-http-rule" {
  security_group_id = aws_security_group.elb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb-https-rule" {
  security_group_id = aws_security_group.elb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb-ruby-rule" {
  security_group_id = aws_security_group.elb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3003
  to_port           = 3003
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb-egress-rule" {
  security_group_id = aws_security_group.elb-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

######################### Launch Template Security Group #######################
#Security group for launch template

resource "aws_security_group" "server-lt-sg" {
  vpc_id      = aws_vpc.main-vpc.id
  name        = "AppServer-sg"
  description = "Launch Template Security Group"
}

resource "aws_security_group_rule" "server-lt-ssh-rule" {
  security_group_id        = aws_security_group.server-lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.bastion-server-sg.id

}

resource "aws_security_group_rule" "server-lt-http-rule" {
  security_group_id = aws_security_group.server-lt-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80

  source_security_group_id = aws_security_group.elb-sg.id
}

resource "aws_security_group_rule" "server-lt-https-rule" {
  security_group_id        = aws_security_group.server-lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.elb-sg.id
}

resource "aws_security_group_rule" "server-lt-ruby-rule" {
  security_group_id        = aws_security_group.server-lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3003
  to_port                  = 3003
  source_security_group_id = aws_security_group.elb-sg.id
}

resource "aws_security_group_rule" "server-lt-mysql-rule" {
  security_group_id        = aws_security_group.server-lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.rds-instance-sg.id
}

resource "aws_security_group_rule" "server-lt-nfs-rule" {
  security_group_id        = aws_security_group.server-lt-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.efs-sg.id
}


resource "aws_security_group_rule" "server-lt-egress-rule" {
  security_group_id = aws_security_group.server-lt-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


########################## Security EFS ##########################
#EFS security group
resource "aws_security_group" "efs-sg" {
  vpc_id      = aws_vpc.main-vpc.id
  name        = "EFS-sg"
  description = "EFS Security Group"
}

resource "aws_security_group_rule" "efs-nfs-rule" {
  security_group_id        = aws_security_group.efs-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.server-lt-sg.id
}

resource "aws_security_group_rule" "efs-egress-rule" {
  security_group_id = aws_security_group.efs-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
##################################################################
# Bastion server securrity group
## Create security group
resource "aws_security_group" "bastion-server-sg" {
  vpc_id      = aws_vpc.main-vpc.id
  name        = "Bastion-sg"
  description = "Public Subnet Instance Security Group"
}

#Add rule to SSH into EC2 instance
resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.bastion-server-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

#Add rule to HTTP into EC2 instance
resource "aws_security_group_rule" "http-rule" {
  security_group_id = aws_security_group.bastion-server-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

#Add rule to HTTPS into EC2 instance
resource "aws_security_group_rule" "https-rule" {
  security_group_id = aws_security_group.bastion-server-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

#Add rule to Ruby into EC2 instance
resource "aws_security_group_rule" "ruby-rule" {
  security_group_id = aws_security_group.bastion-server-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3003
  to_port           = 3003
  cidr_blocks       = ["0.0.0.0/0"]
}

#Egress rule
resource "aws_security_group_rule" "egress-rule" {
  security_group_id = aws_security_group.bastion-server-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

############################################################################################
#################################  RDS Security Group ######################################

#RDS Security Group
resource "aws_security_group" "rds-instance-sg" {
  vpc_id      = aws_vpc.main-vpc.id
  name        = "RDS-sg"
  description = "RDS Security Group"
}

# Allows traffic from the launch template of the app server
resource "aws_security_group_rule" "lt-mysql-rule" {
  security_group_id        = aws_security_group.rds-instance-sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.server-lt-sg.id
}

# # Allow traffic from the launch template of the bastion server
# resource "aws_security_group_rule" "bastion-mysql-rule" {
#   security_group_id        = aws_security_group.rds-instance-sg.id
#   type                     = "ingress"
#   protocol                 = "tcp"
#   from_port                = 5432
#   to_port                  = 5432
#   source_security_group_id = aws_security_group.bastion-server-sg.id
# }

resource "aws_security_group_rule" "rds-egress-rule" {
  security_group_id = aws_security_group.rds-instance-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

