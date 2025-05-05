# EC2 Instance 1 - placed in a private subnet
resource "aws_instance" "ec2_1" {
  ami                    = var.ami_id # Amazon Linux 2023 AMI
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = var.security_group_ids

  # Attach IAM role for SSM Session Manager access
  iam_instance_profile = var.iam_instance_profile

  # Script that installs web server
  user_data = file(var.user_data_file)

  tags = {
    Name = "ec2-1-internship-maksym"
    Monitoring = "enabled"
  }
}

# EC2 Instance 2 - placed in a second private subnet
resource "aws_instance" "ec2_2" {
  ami                    = var.ami_id # Amazon Linux 2023 AMI
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[1]
  vpc_security_group_ids = var.security_group_ids

  # Attach IAM role for SSM Session Manager access
  iam_instance_profile = var.iam_instance_profile

  # Script that installs web server
  user_data = file(var.user_data_file)

  tags = {
    Name = "ec2-2-internship-maksym"
    Monitoring = "enabled"
  }
}

