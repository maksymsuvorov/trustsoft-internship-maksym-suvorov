resource "aws_instance" "ec2-1" {
  ami = "ami-0ce8c2b29fcc8a346"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet-private-1.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile = aws_iam_instance_profile.ssm-instance-profile.name

  user_data = file("scripts/userdata.sh")
  
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

  user_data = file("scripts/userdata.sh")

  tags = {
    Name: "ec2-2-internship-maksym"
  }
}
