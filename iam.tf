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
