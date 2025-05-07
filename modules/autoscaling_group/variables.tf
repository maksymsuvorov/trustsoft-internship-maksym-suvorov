variable "template_web_server_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "lb_target_group_arns" {
  type = list(string)
}
