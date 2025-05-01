# Security group for the Application Load Balancer (ALB)
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg-internship-maksym"
  vpc_id = var.vpc_id

  # Allow incoming HTTP traffic (port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # all protocols
    cidr_blocks = var.alb_cidr_blocks
  }
}

# Security group for EC2 instances (private)
resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg-internship-maksym"
  vpc_id = var.vpc_id

  # Allow incoming HTTP traffic (port 80) ONLY from ALB security group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # restrict to ALB only
  }

  # Allow all outbound traffic (needed for NAT access, SSM agent, updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_cidr_blocks
  }
}

