output "launch_template_id" {
  description = "ID of the created launch template"
  value       = aws_launch_template.web_server.id
}

output "launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.web_server.name
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.web_server.latest_version
}
