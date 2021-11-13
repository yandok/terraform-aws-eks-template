/**
 * # terraform-aws-load-balancer
 *
 * This module is used for creating an application load balancer with HTTPS-listener
 *  * HTTP - listener redirects to HTTPS
 *  * HTTPS - listeners default-action is to return a fixed response
 */

module "security_group_alb_external" {
  source              = "terraform-aws-modules/security-group/aws"
  version             = "4.4.0"
  name                = "${var.project}-${terraform.workspace}-alb-external-sg"
  description         = "Security group for external ALB"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "https-443-tcp", "https-8443-tcp", "http-8080-tcp"]
  egress_rules        = ["all-all"]
  tags = {
    Name = "${var.project}-${terraform.workspace}-alb-external-sg"
  }
}

module "alb-external" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "6.3.0"
  name               = "${var.project}-${terraform.workspace}-alb-external"
  load_balancer_type = "application"
  internal           = false
  vpc_id             = var.vpc_id
  security_groups    = [module.security_group_alb_external.security_group_id]
  subnets            = [var.public_subnets[0], var.public_subnets[1]]
  idle_timeout       = 120
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = module.alb-external.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = module.alb-external.lb_arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  // listener has fixed response; forward actions are set up with host rules
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ALB & HTTPS Listener Initialized. Create Listener-Rules to forward traffic."
      status_code  = "200"
    }
  }
}