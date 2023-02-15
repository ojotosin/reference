# allocates an elastic ip address to be used for public subnet az1
resource "aws_eip" "az1_eip" {
  vpc                           = true
  
  tags                          = {
    Name                        = "AZ1 eip"
  }
}

# allocates an elastic ip address to be used for public subnet az2
resource "aws_eip" "az2_eip" {
  vpc                           = true
  
  tags                          = {
    Name                        = "AZ2 eip"
  }
}

# creates a nat gateway in public subnet az1
resource "aws_nat_gateway" "AZ1_ngw" {
  allocation_id                 = aws_eip.az1_eip.id
  subnet_id                     = aws_subnet.public_subnetAZ1.id

  tags = {
    Name = "AZ1-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

# creates a nat gateway in public subnet AZ2 
resource "aws_nat_gateway" "AZ2_ngw" {
  allocation_id                 = aws_eip.az2_eip.id
  subnet_id                     = aws_subnet.public_subnetAZ2.id

  tags = {
    Name = "AZ2-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on                    = [aws_internet_gateway.igw]
}

# creates a private route table for az1
resource "aws_route_table" "private_rtb_AZ1" {
  vpc_id                        = aws_vpc.vpc.id

  route {
    cidr_block                  = "0.0.0.0/0"
    nat_gateway_id              = aws_nat_gateway.AZ1_ngw.id
  }
  tags                          = {
    "Name"                      = "private route table AZ1"
  }
}

# associates private app subnet az1 with private route table az1
resource "aws_route_table_association" "appsub_az1_association" {
  subnet_id                     = aws_subnet.private_appsubnetAZ1.id
  route_table_id                = aws_route_table.private_rtb_AZ1.id
}

# associates private data subnet az1 with private route table az1
resource "aws_route_table_association" "datasub_az1_association" {
  subnet_id                     = aws_subnet.private_datasubnetAZ1.id
  route_table_id                = aws_route_table.private_rtb_AZ1.id
}

# creates a private route table for az2
resource "aws_route_table" "private_rtb_AZ2" {
  vpc_id                        = aws_vpc.vpc.id

  route {
    cidr_block                  = "0.0.0.0/0"
    nat_gateway_id              = aws_nat_gateway.AZ2_ngw.id

  }

  tags                          = {
    "Name"                      = "private route table AZ2"
  }
}


# associates private app subnet az2 with private route table az2
resource "aws_route_table_association" "appsub_az2_association" {
  subnet_id                     = aws_subnet.private_appsubnetAZ2.id
  route_table_id                = aws_route_table.private_rtb_AZ2.id
}

# associates private data subnet az1 with private route table az2
resource "aws_route_table_association" "datasub_az2_association" {
  subnet_id                     = aws_subnet.private_datasubnetAZ2.id
  route_table_id                = aws_route_table.private_rtb_AZ2.id
}
