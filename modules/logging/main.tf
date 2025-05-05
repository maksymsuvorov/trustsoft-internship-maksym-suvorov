resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "vpc-flow-log-group-internship-maksym"
  retention_in_days = 3
}

resource "aws_flow_log" "vpc_flow_log" {
  vpc_id               = var.vpc_id
  iam_role_arn         = var.iam_role_arn
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
}
