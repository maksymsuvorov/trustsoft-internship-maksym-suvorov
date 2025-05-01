# IAM Role that allows EC2 to assume permissions (SSM access)
resource "aws_iam_role" "ssm_ec2_role" {
  name = "iam-role-internship-maksym"

  # Define who can assume this role, EC2 in this case
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com" # EC2 service is allowed to assume this role
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Instance profile that attaches the IAM role to an EC2 instance
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm-ec2-instance-profile-internship-maksym"
  role = aws_iam_role.ssm_ec2_role.name
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
# This grants the necessary permissions for SSM
resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.ssm_ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

