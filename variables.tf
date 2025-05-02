###############################################################################
# Provider & Backend Settings
###############################################################################

variable "region" {
  description = "AWS Region where all resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "backend_bucket" {
  description = "Name of the S3 bucket used to store Terraform state"
  type        = string
  default     = "s3-remote-backend-internship-maksym"
}

variable "backend_dynamodb_table" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  type        = string
  default     = "dynamodb-state-lock-table-internship-maksym"
}

###############################################################################
# Networking Module Inputs
###############################################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "List of Availability Zones to distribute subnets and NAT Gateways"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

###############################################################################
# Security Module Inputs
###############################################################################

variable "alb_allowed_cidrs" {
  description = "List of CIDR blocks permitted to connect to the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

###############################################################################
# Compute Module Inputs
###############################################################################

variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type        = string
  default     = "ami-0ce8c2b29fcc8a346"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "user_data_file" {
  description = "Path to the bootstrap script for EC2"
  type        = string
  default     = "scripts/userdata.sh"
}

###############################################################################
# Monitoring Module Inputs
###############################################################################

variable "email_addresses" {
  description = "List of email addresses to receive CloudWatch alarm notifications"
  type        = list(string)
  default     = ["maksym.suvorov@trustsoft.eu"]
}
