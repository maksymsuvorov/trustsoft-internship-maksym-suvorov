variable "instance_ids" {
  description = "List of EC2 instance IDs for which to create CloudWatch alarms"
  type = list(string)
}

variable "email_addresses" {
  description = "List of email addresses to subscribe to the SNS alert topic"
  type = list(string)
}
