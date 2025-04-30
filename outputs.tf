# Public DNS name of the Application Load Balancer
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.lb.dns_name
}

# Private IP of EC2 instance 1
output "ec2_1_private_ip" {
  description = "Private IP address of EC2 instance 1"
  value       = aws_instance.ec2-1.private_ip
}

# Private IP of EC2 instance 2
output "ec2_2_private_ip" {
  description = "Private IP address of EC2 instance 2"
  value       = aws_instance.ec2-2.private_ip
}

# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

