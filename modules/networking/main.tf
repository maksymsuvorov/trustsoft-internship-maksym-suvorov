# Create a custom VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "vpc-internship-maksym"
  }
}

# Public Subnet in AZ1 (with auto-assign public IP)
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]

  tags = {
    Name = "public-subnet-1-internship-maksym"
  }
}

# Public Subnet in AZ2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[1]

  tags = {
    Name = "public-subnet-2-internship-maksym"
  }
}

# Private Subnet in AZ1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[0]
  availability_zone = var.availability_zones[0]

  tags = {
    Name = "private-subnet-1-internship-maksym"
  }
}

# Private Subnet in AZ2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[1]
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private-subnet-2-internship-maksym"
  }
}

# Internet Gateway for public subnets (used by ALB, NATGW)
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gw-internship-maksym"
  }
}

# Route table for public subnets (routes to Internet Gateway)
resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "public-subnet-rt-internship-maksym"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet_rt.id
}

resource "aws_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet_rt.id
}


# Elastic IPs for each NAT Gateway (one per AZ)
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-1-internship-maksym"
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"

  tags = {
    Name = "nat-eip-2-internship-maksym"
  }
}

# NAT Gateway in public subnet 1 (AZ1)
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "nat-gw-1-internship-maksym"
  }
}

# NAT Gateway in public subnet 2 (AZ2)
resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "nat-gw-2-internship-maksym"
  }
}

# Route table for private subnet 1 (routes through NAT Gateway 1)
resource "aws_route_table" "private_subnet_rt_1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "private-subnet-rt-1-internship-maksym"
  }
}

# Route table for private subnet 2 (routes through NAT Gateway 2)
resource "aws_route_table" "private_subnet_rt_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "private-subnet-rt-2-internship-maksym"
  }
}

# Associate private subnets with their respective route tables
resource "aws_route_table_association" "private_subnet_assoc-1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet_rt_1.id
}

resource "aws_route_table_association" "private_subnet_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet_rt_2.id
}
