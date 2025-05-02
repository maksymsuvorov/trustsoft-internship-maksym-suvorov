variable "vpc_id" {
  description = "The ID of the VPC in which to create security groups"
  type        = string
}

variable "alb_cidr_blocks" {
  description = "List of CIDR blocks permitted to reach the ALB"
  type        = list(string)
}
