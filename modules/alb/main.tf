# Target Group for EC2 instances (used by ALB)
resource "aws_lb_target_group" "lb_tg" {
  name        = "lb-tg-internship-maksym"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance" # Targets are EC2 instance IDs

  # Health check settings for the target group
  health_check {
    path                = "/" # ALB checks this path
    protocol            = "HTTP"
    matcher             = "200" # Expect HTTP 200 OK
    interval            = 30    # Check every 30 seconds
    timeout             = 5     # Fail check if no response in 5 sec
    healthy_threshold   = 3     # 3 consecutive successful checks = healthy
    unhealthy_threshold = 2     # 2 failures = unhealthy
  }
}

# Attach EC2-1 to the target group
resource "aws_lb_target_group_attachment" "ec2_1_attachment" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = var.target_instance_ids[0]
  port             = 80 # The port the app is listening on inside the instance
}

# Attach EC2-2 to the target group
resource "aws_lb_target_group_attachment" "ec2_2_attachment" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = var.target_instance_ids[1]
  port             = 80
}

# Application Load Balancer (ALB)
resource "aws_lb" "lb" {
  name               = "lb-internship-maksym"
  internal           = false                   # Internet-facing load balancer
  load_balancer_type = "application"           # Layer 7 LB (HTTP/HTTPS)
  security_groups    = [var.security_group_id] # Allow port 80 inbound
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false # Can be set true in production
}

# Listener for ALB on port 80 (HTTP)
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  # Default action is to forward all traffic to the EC2 target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

