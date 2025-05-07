output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = aws_lb.lb.dns_name
}

output "alb_arn" {
  value = aws_lb.lb.arn_suffix
}

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.lb_tg.arn
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.lb_tg.arn_suffix
}
