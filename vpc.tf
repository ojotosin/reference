# creates the vpc
resource "aws_vpc" "vpc" {
  cidr_block                = var.dev_vpc_cidr
  instance_tenancy          = "default"
  enable_dns_hostnames      = true

  tags                      = {
    Name                    = "dev-vpc"
  }
}

# creates the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id                    = aws_vpc.vpc.id

  tags                      = {
    Name                    = "dev-igw"
  }
}

# creates public subnet in az1
resource "aws_subnet" "public_subnetAZ1" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.public_subnetAZ1_cidr
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = true
  tags                      = {
    Name                    = "public-subnetAZ1"
  }
} 

# creates public subnet in az2
resource "aws_subnet" "public_subnetAZ2" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.public_subnetAZ2_cidr
  availability_zone         = "us-east-1b"
  map_public_ip_on_launch   = true

  tags                      = {
    Name                    = "public-subnetAZ2"
  }
}

# creates route table
resource "aws_route_table" "public_route_table" {
  vpc_id                    = aws_vpc.vpc.id

  route {
    cidr_block              = var.public_rtb_cidr
    gateway_id              = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

# associates public subnet AZ1 with public route table
resource "aws_route_table_association" "AZ1" {
  subnet_id                 = aws_subnet.public_subnetAZ1.id
  route_table_id            = aws_route_table.public_route_table.id
}

# associates public subnet AZ2 with public route table
resource "aws_route_table_association" "AZ2" {
  subnet_id                 = aws_subnet.public_subnetAZ2.id
  route_table_id            = aws_route_table.public_route_table.id
}

# creates private app subnet in az1
resource "aws_subnet" "private_appsubnetAZ1" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.private_appsubnetAZ1_cidr
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = false

  tags                      = {
    Name                    = "private-appsubnetAZ1"
  }
}

# creates private app subnet in az2
resource "aws_subnet" "private_appsubnetAZ2" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.private_appsubnetAZ2_cidr
  availability_zone         = "us-east-1b"
  map_public_ip_on_launch   = false

  tags                      = {
    Name                    = "private-appsubnetAZ2"
  }
}

# creates private data subnet in az1
resource "aws_subnet" "private_datasubnetAZ1" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.private_datasubnetAZ1_cidr
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = false

  tags                      = {
    Name                    = "private-datasubnetAZ1"
  }
}

# creates private data subnet in az2
resource "aws_subnet" "private_datasubnetAZ2" {
  vpc_id                    = aws_vpc.vpc.id
  cidr_block                = var.private_datasubnetAZ2_cidr
  availability_zone         = "us-east-1b"
  map_public_ip_on_launch   = false

  tags                      = {
    Name                    = "private-appsubnetAZ2"
  }
}
