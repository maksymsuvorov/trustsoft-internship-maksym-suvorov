variable "user_data_file" {
  description = "Path to the local script to bootstrap each EC2 instance"
  type        = string
}

variable "ec2_sg_id" {
  type = string
}

variable "ec2_profile_name" {
  type = string
}
