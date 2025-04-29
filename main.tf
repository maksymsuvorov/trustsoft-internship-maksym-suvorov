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
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"
    tags = {
        Name = "subnet-public-1-internship-maksym"
    }
}

resource "aws_subnet" "subnet-public-2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1b"
    tags = {
        Name = "subnet-public-2-internship-maksym"
    }
}

resource "aws_subnet" "subnet-private-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "eu-west-1a"
    tags = {
        Name = "subnet-private-1-internship-maksym"
    }
}

resource "aws_subnet" "subnet-private-2" {
    vpc_id = aws_vpc.vpc.id
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


resource "aws_security_group" "alb-sg" {
  name= "alb-sg-internship-maksym"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2-sg" {
  name = "ec2-sg-internship-maksym"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "ssm-ec2-role" {
  name = "iam-role-internship-maksym"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ssm-instance-profile" {
  name = "ssm-ec2-instance-profile-internship-maksym"
  role = aws_iam_role.ssm-ec2-role.name
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role = aws_iam_role.ssm-ec2-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
