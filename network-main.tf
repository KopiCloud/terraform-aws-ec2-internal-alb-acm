###########################
## Network Module - Main ##
###########################

# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-vpc"
    Environment = var.app_environment
  }
}

# Define the private subnet #1
resource "aws_subnet" "private-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = var.aws_az_1

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-private-subnet-1"
    Environment = var.app_environment
  }
}

# Define the private subnet #2
resource "aws_subnet" "private-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = var.aws_az_2

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-private-subnet-2"
    Environment = var.app_environment
  }
}

# Define the private subnet #3
resource "aws_subnet" "private-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_3
  availability_zone = var.aws_az_3

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-private-subnet-3"
    Environment = var.app_environment
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.aws_az_1

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-public-subnet"
    Environment = var.app_environment
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-igw"
    Environment = var.app_environment
  }
}

# Create a Public IP for the NAT Gateway
resource "aws_eip" "nat-eip" {
  vpc = true

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-nat-eip"
    Environment = var.app_environment
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "nat" {
  depends_on = [aws_internet_gateway.gw]

  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-nat-gateway"
    Environment = var.app_environment
  }
}

# Define the private route table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  
  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-private-subnet-rt"
    Environment = var.app_environment
  }
}

# Assign the private route table to the private subnet 1
resource "aws_route_table_association" "private-rt-1-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private-rt.id
}

# Assign the private route table to the private subnet 2
resource "aws_route_table_association" "private-rt-2-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private-rt.id
}

# Assign the private route table to the private subnet 3
resource "aws_route_table_association" "private-rt-3-association" {
  subnet_id      = aws_subnet.private-subnet-3.id
  route_table_id = aws_route_table.private-rt.id
}

# Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-public-subnet-rt"
    Environment = var.app_environment
  }
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}
