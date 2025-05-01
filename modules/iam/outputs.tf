output "instance_profile" {
  value = aws_iam_instance_profile.ssm_instance_profile
}

output "role_arn" {
  value = aws_iam_role.ssm_ec2_role.arn
}