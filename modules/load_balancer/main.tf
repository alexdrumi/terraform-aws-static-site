resource "aws_lb" "load_balancer" {
  name                       = "application-load-balancer"
  load_balancer_type         = "application" #OSI LAYER 7, network w work on OSI LAYER 4
  security_groups            = [var.security_group]
  subnets                    = var.subnets #in the top of the file we defined this
  enable_deletion_protection = false                                                 #if this is true, AWS prevents the ALB from being destroyed

  #depends on the internet gateway
  # depends_on = [aws_internet_gateway.gw] #?

  tags = {
    Name = "application-load-balancer"
  }
}

resource "aws_lb_target_group" "lg_target" {
  name     = "lg-target"
  port     = 80 #http-> maybe poull fropm vars?
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name = "target group for application load balancer"
  }


  #health check here?
  health_check {
    interval            = 30
    path                = "/health.html"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lg_target.arn
  }

  tags = {
    Name = "application-load-balancer listener"
  }
}