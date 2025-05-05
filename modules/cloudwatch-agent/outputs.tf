output "cloudwatch_ssm_parameter_name" {
  description = "SSM parameter name for CloudWatch Agent config"
  value       = aws_ssm_parameter.cw_agent_config.name
}

output "cloudwatch_ssm_document_name" {
  description = "SSM document for installing CloudWatch Agent"
  value       = aws_ssm_document.cw_agent_install.name
}

output "cloudwatch_ssm_association_id" {
  description = "SSM Association ID for CloudWatch Agent deployment"
  value       = aws_ssm_association.cw_agent_association.id
}
