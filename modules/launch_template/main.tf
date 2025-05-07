data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Creates a Launch Template to be used by an Auto Scaling Group
resource "aws_launch_template" "web_server" {
  name_prefix   = "web-server-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  # Attach the EC2 security group to the launched instances
  vpc_security_group_ids = [var.ec2_sg_id]

  # Attach IAM instance profile
  iam_instance_profile {
    name = var.ec2_profile_name
  }

  user_data = base64encode(file(var.user_data_file))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "autoscaling-web-internship-maksym"
    }
  }
}

