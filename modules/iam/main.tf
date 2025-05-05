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

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ssm_ec2_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


# 1) IAM Role assumable by the VPC Flow Logs service
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-flow-logs-role-internship-maksym"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# 2) Custom Policy granting CW Logs permissions
resource "aws_iam_policy" "vpc_flow_logs_policy" {
  name        = "VPCFlowLogsDeliveryPolicy-IntersnhipMaksym"
  description = "Allows VPC Flow Logs service to write flow logs into CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}

# 3) Attach the policy to the role
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_attach" {
  role       = aws_iam_role.vpc_flow_logs_role.name
  policy_arn = aws_iam_policy.vpc_flow_logs_policy.arn
}
