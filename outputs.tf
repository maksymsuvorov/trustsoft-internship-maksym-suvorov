############################
# NETWORKING OUTPUTS
############################

# ID of the VPC created
output "vpc_id" {
  value = module.networking.vpc_id
}

# List of public subnet IDs across AZs
output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

# List of private subnet IDs across AZs
output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

############################
# SECURITY GROUPS OUTPUTS
############################

# Security Group ID used by Application Load Balancer
output "alb_sg_id" {
  value = module.security.alb_sg_id
}

# Security Group ID used by EC2 instances
output "ec2_sg_id" {
  value = module.security.ec2_sg_id
}

############################
# IAM OUTPUTS
############################

# IAM role ARN attached to EC2 instances
output "iam_role_arn" {
  value = module.iam.ec2_role_arn
}

# EC2 instance profile name used for SSM access
output "instance_profile_name" {
  value = module.iam.instance_profile
}

############################
# COMPUTE OUTPUTS
############################

# List of EC2 instance IDs created
output "ec2_instance_ids" {
  value = module.compute.instance_ids
}

# Private IP addresses of EC2 instances
output "ec2_private_ips" {
  value = module.compute.private_ips
}

############################
# APPLICATION LOAD BALANCER OUTPUTS
############################

# Public DNS name of the ALB to access the application
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

# ARN of the ALB target group
output "target_group_arn" {
  value = module.alb.target_group_arn
}

############################
# AWS CONFIG OUTPUTS
############################

# Name of the AWS Config compliance rule
output "config_rule_name" {
  value = module.config.config_rule_name
}

# ARN of the AWS Config compliance rule
output "config_rule_arn" {
  value = module.config.config_rule_arn
}

############################
# CLOUDWATCH AGENT OUTPUTS
############################

# Name of the SSM Parameter storing the CloudWatch Agent config
output "cloudwatch_ssm_parameter_name" {
  value = module.cloudwatch-agent.cloudwatch_ssm_parameter_name
}

# Name of the SSM Document that installs the CloudWatch Agent
output "cloudwatch_ssm_document_name" {
  value = module.cloudwatch-agent.cloudwatch_ssm_document_name
}

# ID of the SSM Association that applies the CloudWatch Agent setup
output "cloudwatch_ssm_association_id" {
  value = module.cloudwatch-agent.cloudwatch_ssm_association_id
}

############################
# LAUNCH TEMPLATE OUTPUTS
############################

# ID of the EC2 Launch Template used by Auto Scaling Group
output "launch_template_id" {
  value = module.launch_template.launch_template_id
}

# Name of the EC2 Launch Template
output "launch_template_name" {
  value = module.launch_template.launch_template_name
}

############################
# AUTO SCALING GROUP OUTPUTS
############################

# Name of the Auto Scaling Group
output "asg_name" {
  value = module.autoscaling_group.asg_name
}

############################
# MONITORING OUTPUTS
############################

# ARN of the SNS topic used for alarm notifications
output "sns_topic_arn" {
  value = module.monitoring.sns_topic_arn
}
