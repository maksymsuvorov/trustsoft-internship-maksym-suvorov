# List of email addresses that will receive CloudWatch alarm notifications via SNS
variable "email_address" {
  description = "List of emails for CloudWatch alarm notifications"
  type        = list(string)
  default     = [
    "maksym.suvorov@trustsoft.eu",
    "vladislav.yurikov@trustsoft.eu"
  ]
}

# Default AWS region to deploy resources in
variable "region" {
  description = "Default AWS region to deploy the infrastructure"
  type        = string
  default     = "eu-west-1"
}

# Availability Zone 1
variable "availability-zone-1" {
  description = "Primary availability zone (AZ 1)"
  type        = string
  default     = "eu-west-1a"
}

# Availability Zone 2
variable "availability-zone-2" {
  description = "Secondary availability zone (AZ 2)"
  type        = string
  default     = "eu-west-1b"
}

