# Create VPC
resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.vpc_tags

}

###################################### Subnets #######################################
# Public subnet AZ1 and 2
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.0.0/23"
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_az1-${local.name_acc_prefix}"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.2.0/23"
  availability_zone = "us-east-1b"
  #map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_az2-${local.name_acc_prefix}"
  }
}

# App Server Private Subnet AZ 1 and 2
resource "aws_subnet" "app_server_private_az1" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.4.0/25" #10.0.4.0/25
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = false

  tags = {
    Name = "app_server_private_subnet_az1-${local.name_acc_prefix}"
  }
}

resource "aws_subnet" "app_server_private_az2" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = "10.0.4.128/25" #10.0.4.128/25
  availability_zone = "us-east-1b"
  #map_public_ip_on_launch = false

  tags = {
    Name = "app_server_private_subnet_az2-${local.name_acc_prefix}"
  }
}
#Calculate CIDRs
resource "aws_subnet" "rds_private_az1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.8.0/22" #10.0.8.0/22
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "rds_private_subnet_az1-${local.name_acc_prefix}"
  }
}

resource "aws_subnet" "rds_private_az2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.12.0/22" #10.0.12.0/22
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "rds_private_subnet_az2-${local.name_acc_prefix}"
  }
}


################################### Internet Gateway ####################################
resource "aws_internet_gateway" "main-int-gateway" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    "Name" = "clixx-vpc-igw"
  }
}

# Edit the vpc main route table
resource "aws_route" "main-vpc-routetable_default" {
  route_table_id         = aws_vpc.main-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main-int-gateway.id
}

resource "aws_route_table_association" "mainvpc_rt_public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_vpc.main-vpc.main_route_table_id
}

resource "aws_route_table_association" "mainvpc_rt_public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_vpc.main-vpc.main_route_table_id
}

##################################################################################
## NAT Gateways, Private Subnet Route Tables
# Create Elastic IP
resource "aws_eip" "nat1" {
  vpc = true
}

resource "aws_nat_gateway" "public-nat1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_az1.id
  depends_on    = [aws_eip.nat1]
}


####### Create Route Table For Private Subnet and include NAt Gateway inside
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-nat1.id
  }
}

# Associate route table with the private subnet
resource "aws_route_table_association" "rt-private_az1" {
  subnet_id      = aws_subnet.app_server_private_az1.id
  route_table_id = aws_route_table.private1.id
}

############################
resource "aws_eip" "nat2" {
  vpc = true
}

resource "aws_nat_gateway" "public-nat2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_az2.id
  depends_on    = [aws_eip.nat2]
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public-nat2.id
  }
}

resource "aws_route_table_association" "rt-private_az2" {
  subnet_id      = aws_subnet.app_server_private_az2.id
  route_table_id = aws_route_table.private2.id
}

