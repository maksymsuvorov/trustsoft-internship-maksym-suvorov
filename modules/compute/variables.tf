variable "ami_id" {
  description = "AMI ID to use for EC2 instances"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs into which to launch the EC2 instances"
  type = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to each EC2 instance"
  type = list(string)
}

variable "iam_instance_profile" {
  description = "Name of the IAM Instance Profile that contains the SSM/CloudWatch role"
  type = string
}

variable "user_data_file" {
  description = "Path to the local script to bootstrap each EC2 instance"
  type = string
}
