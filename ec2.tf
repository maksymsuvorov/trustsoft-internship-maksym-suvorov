# EC2 Instance 1 - placed in a private subnet
resource "aws_instance" "ec2-1" {
  ami                    = "ami-0ce8c2b29fcc8a346"      # Amazon Linux 2023 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-private-1.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  # Attach IAM role for SSM Session Manager access
  iam_instance_profile   = aws_iam_instance_profile.ssm-instance-profile.name

  # Script that installs web server
  user_data = file("scripts/userdata.sh")

  tags = {
    Name = "ec2-1-internship-maksym"
  }
}

# EC2 Instance 2 - placed in a second private subnet
resource "aws_instance" "ec2-2" {
  ami                    = "ami-0ce8c2b29fcc8a346"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-private-2.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  # Same IAM role and user_data as EC2-1
  iam_instance_profile   = aws_iam_instance_profile.ssm-instance-profile.name
  user_data              = file("scripts/userdata.sh")

  tags = {
    Name = "ec2-2-internship-maksym"
  }
}

