###############################################################################
# Networking Module Outputs
###############################################################################

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.networking.internet_gw_id
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.networking.nat_gateway_ids
}

###############################################################################
# Security Module Outputs
###############################################################################

output "alb_sg_id" {
  description = "Security Group ID for the Application Load Balancer"
  value       = module.security.alb_sg_id
}

output "ec2_sg_id" {
  description = "Security Group ID for EC2 instances"
  value       = module.security.ec2_sg_id
}

###############################################################################
# IAM Module Outputs
###############################################################################

output "instance_profile" {
  description = "Name of the IAM Instance Profile attached to EC2"
  value       = module.iam.instance_profile
}

output "role_arn" {
  description = "ARN of the IAM role for EC2 instances"
  value       = module.iam.role_arn
}

###############################################################################
# Compute Module Outputs
###############################################################################

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = module.compute.instance_ids
}

output "private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.compute.private_ips
}

###############################################################################
# ALB Module Outputs
###############################################################################

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_group_arn
}

###############################################################################
# Monitoring Module Outputs
###############################################################################

output "sns_topic_arn" {
  description = "ARN of the SNS topic for CloudWatch alerts"
  value       = module.monitoring.sns_topic_arn
}
