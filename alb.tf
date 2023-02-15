# creates application load balancer
resource "aws_lb" "application_load_balancer" {
  name                              = "dev-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.ALB_sg.id]

  subnet_mapping {
    subnet_id                       = aws_subnet.public_subnetAZ1.id
  }

  subnet_mapping {
    subnet_id                       = aws_subnet.public_subnetAZ2.id
  }

  enable_deletion_protection        = false

  tags = {
    "Name" = "dev-alb"
  }
}

# creates the target group
resource "aws_lb_target_group" "alb_TG" {
  name                              = "dev-TG"
  target_type                       = "instance"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.vpc.id
  
  health_check {
    healthy_threshold               = 5
    interval                        = 30
    matcher                         = "200,301,302"
    path                            = "/"
    port                            = "traffic-port" 
    protocol                        = "HTTP" 
    timeout                         = 5 
    unhealthy_threshold             = 2


  }

  tags = {
    "Name"                          = "dev-TG"
  }
}

# creates a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn                 = aws_lb.application_load_balancer.arn
  port                              = 80
  protocol                          = "HTTP"

  default_action {
    type                            = "redirect"

    redirect {
      host                          = "#{host}"
      path                          =  "/#{host}"
      port                          = "443"
      protocol                      = "HTTPS"
      status_code                   = "HTTP_301"
    }
  }
}

# creates a listener on port 443 with forward action
resource "aws_lb_listener" "front_end" {
  load_balancer_arn                 = aws_lb.application_load_balancer.arn
  port                              = "443"
  protocol                          = "HTTPS"
  ssl_policy                        = "ELBSecurityPolicy-2016-08"
  certificate_arn                   = var.ssl_certificate_arn

  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.alb_TG.arn
  }
}
