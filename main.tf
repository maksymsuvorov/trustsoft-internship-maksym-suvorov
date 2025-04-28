terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}


resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  tags = {
    Name = "vpc-internship-maksym"
  }
}


resource "aws_subnet" "subnet-public-1" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"
    tags = {
        Name = "subnet-public-1-internship-maksym"
    }
}

resource "aws_subnet" "subnet-public-2" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1b"
    tags = {
        Name = "subnet-public-2-internship-maksym"
    }
}

resource "aws_subnet" "subnet-private-1" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.11.0/24"
    availability_zone = "eu-west-1a"
    tags = {
        Name = "subnet-private-1-internship-maksym"
    }
}

resource "aws_subnet" "subnet-private-2" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.0.12.0/24"
    availability_zone = "eu-west-1b"
    tags = {
        Name = "subnet-private-2-internship-maksym"
    }
}


resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gw-internship-maksym"
  }
}


resource "aws_route_table" "public-subnet-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }

  tags = {
    Name: "public-subnet-rt-internship-maksym"
  }
}


resource "aws_eip" "nat-eip-1" {
  domain = "vpc"

  tags = {
    Name: "nat-eip-1-internship-maksym"
  }
}

resource "aws_eip" "nat-eip-2" {
  domain = "vpc"

  tags = {
    Name: "nat-eip-2-internship-maksym"
  }
}


resource "aws_nat_gateway" "nat-gw-1" {
  allocation_id = aws_eip.nat-eip-1.id
  subnet_id = aws_subnet.subnet-public-1.id

  tags = {
    Name: "nat-gw-1-internship-maksym"
  }
}

resource "aws_nat_gateway" "nat-gw-2" {
  allocation_id = aws_eip.nat-eip-2.id
  subnet_id = aws_subnet.subnet-public-2.id

  tags = {
    Name: "nat-gw-2-internship-maksym"
  }
}


resource "aws_route_table" "private-subnet-rt-1" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-1.id
  }

  tags = {
    Name: "private-subnet-rt-1-internship-maksym"
  }
}

resource "aws_route_table" "private-subnet-rt-2" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-2.id
  }

  tags = {
    Name: "private-subnet-rt-2-internship-maksym"
  }
}
