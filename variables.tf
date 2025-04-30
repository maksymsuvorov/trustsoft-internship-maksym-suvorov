variable "email_address" {
  description = "List of emails for CloudWatch alarm"
  type        = list(string)
  default     = ["maksym.suvorov@trustsoft.eu", "vladislav.yurikov@trustsoft.eu"]
}
