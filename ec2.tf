resource "aws_instance" "ec2-1" {
  ami = "ami-0ce8c2b29fcc8a346"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet-private-1.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm-instance-profile.name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y

    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    
    yum install -y httpd
    
    echo "<h1>Hello from EC2 instance $(hostname)</h1>" > /var/www/html/index.html

    systemctl enable httpd
    systemctl start httpd
  EOF
  )

  tags = {
    Name: "ec2-1-internship-maksym"
  }
}

resource "aws_instance" "ec2-2" {
  ami = "ami-0ce8c2b29fcc8a346"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet-private-2.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm-instance-profile.name

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    
    yum install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent

    yum install -y httpd

    echo "<h1>Hello from EC2 instance $(hostname)</h1>" > /var/www/html/index.html

    systemctl enable httpd
    systemctl start httpd
  EOF
  )

  tags = {
    Name: "ec2-2-internship-maksym"
  }
}
