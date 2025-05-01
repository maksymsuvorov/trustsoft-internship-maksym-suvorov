variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "public_subnet_cidrs" {
  description = "vList of CIDR blocks for public subnets"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type = list(string)
}

variable "availability_zones" {
  description = "List of Availability Zones in the target region"
  type = list(string)
}
