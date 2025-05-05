output "config_rule_name" {
  description = "The name of the AWS Config rule"
  value       = aws_config_config_rule.required_tags.name
}

output "config_rule_id" {
  description = "The ID of the AWS Config rule"
  value       = aws_config_config_rule.required_tags.id
}

output "config_rule_arn" {
  description = "The ARN of the AWS Config rule"
  value       = aws_config_config_rule.required_tags.arn
}

output "config_rule_description" {
  description = "The description of the AWS Config rule"
  value       = aws_config_config_rule.required_tags.description
}

