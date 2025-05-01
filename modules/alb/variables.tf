variable "vpc_id" {
  description = "ID of the VPC in which to create the ALB’s target group"
  type = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where the ALB will be deployed"
  type = list(string)
}

variable "security_group_id" {
  description = "Security group ID to attach to the ALB"
  type = string
}

variable "target_instance_ids" {
  description = "List of EC2 instance IDs to register with the ALB target group"
  type = list(string)
}
