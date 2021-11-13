output "acm_certificate_arn" {
  value = module.acmeu.acm_certificate_arn
  description = "ACM certificate ARN of the for the DNS-record created TLS-certificate"
}