output "dns_name" {
  value = module.alb-external.lb_dns_name
  description = "DNS name of LB"
}

output "zone_id" {
  value = module.alb-external.lb_zone_id
  description = "zone ID of LB"
}

output "security_group_id" {
  value = module.security_group_alb_external.security_group_id
  description = "security group ID from LB"
}

output "https_listener_arn" {
  value = aws_lb_listener.https_listener.arn
  description = "ARN of https-listener of LB"
}