resource "aws_lb" "wp" {
    name               = "${var.environment}-wp-elb"
    internal           = false
    subnets            = aws_subnet.public.*.id
    security_groups    = ["${aws_security_group.lb.id}"]
    load_balancer_type = "application"
}

resource "aws_lb_target_group" "wp" {
  name        = "${var.environment}-wp-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    matcher = "200-499"
  }
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

resource "aws_lb_listener" "wp" {
  load_balancer_arn = aws_lb.wp.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.wp.id
    type             = "forward"
  }
}