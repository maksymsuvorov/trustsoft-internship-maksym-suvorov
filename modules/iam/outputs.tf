output "instance_profile" {
  description = "Name of the IAM Instance Profile for EC2"
  value       = aws_iam_instance_profile.ssm_instance_profile
}

output "role_arn" {
  description = "ARN of the IAM role attached to EC2 instances"
  value       = aws_iam_role.ssm_ec2_role.arn
}