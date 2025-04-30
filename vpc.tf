# Create a custom VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-internship-maksym"
  }
}

# Public Subnet in AZ1 (with auto-assign public IP)
resource "aws_subnet" "subnet-public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability-zone-1

  tags = {
    Name = "subnet-public-1-internship-maksym"
  }
}

# Public Subnet in AZ2
resource "aws_subnet" "subnet-public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability-zone-2

  tags = {
    Name = "subnet-public-2-internship-maksym"
  }
}

# Private Subnet in AZ1
resource "aws_subnet" "subnet-private-1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.availability-zone-1

  tags = {
    Name = "subnet-private-1-internship-maksym"
  }
}

# Private Subnet in AZ2
resource "aws_subnet" "subnet-private-2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.availability-zone-2

  tags = {
    Name = "subnet-private-2-internship-maksym"
  }
}

# Internet Gateway for public subnets (used by ALB, NATGW)
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gw-internship-maksym"
  }
}

# Route table for public subnets (routes to Internet Gateway)
resource "aws_route_table" "public-subnet-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }

  tags = {
    Name = "public-subnet-rt-internship-maksym"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public-subnet-assoc-1" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public-subnet-rt.id
}

resource "aws_route_table_association" "public-subnet-assoc-2" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.public-subnet-rt.id
}


# Elastic IPs for each NAT Gateway (one per AZ)
resource "aws_eip" "nat-eip-1" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-1-internship-maksym"
  }
}

resource "aws_eip" "nat-eip-2" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-2-internship-maksym"
  }
}

# NAT Gateway in public subnet 1 (AZ1)
resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat-eip-1.id
  subnet_id     = aws_subnet.subnet-public-1.id

  tags = {
    Name = "nat-gw-1-internship-maksym"
  }
}

# NAT Gateway in public subnet 2 (AZ2)
resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat-eip-2.id
  subnet_id     = aws_subnet.subnet-public-2.id

  tags = {
    Name = "nat-gw-2-internship-maksym"
  }
}

# Route table for private subnet 1 (routes through NAT Gateway 1)
resource "aws_route_table" "private-subnet-rt-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name = "private-subnet-rt-1-internship-maksym"
  }
}

# Route table for private subnet 2 (routes through NAT Gateway 2)
resource "aws_route_table" "private-subnet-rt-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-2.id
  }

  tags = {
    Name = "private-subnet-rt-2-internship-maksym"
  }
}

# Associate private subnets with their respective route tables
resource "aws_route_table_association" "private-subnet-assoc-1" {
  subnet_id      = aws_subnet.subnet-private-1.id
  route_table_id = aws_route_table.private-subnet-rt-1.id
}

resource "aws_route_table_association" "private-subnet-assoc-2" {
  subnet_id      = aws_subnet.subnet-private-2.id
  route_table_id = aws_route_table.private-subnet-rt-2.id
}
