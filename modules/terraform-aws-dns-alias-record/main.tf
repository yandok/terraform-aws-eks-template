/**
 * # terraform-aws-dns-alias-record
 *
 * This module is used for creating an alias DNS record for a subdomain.
 *
 */

data "aws_route53_zone" "parentzone" {
  name  = var.dns_zone
}

resource "aws_route53_record" "subdomain_record" {
  zone_id = data.aws_route53_zone.parentzone.zone_id
  name    = lookup(var.dns_record,"subdomain","*")
  type    = "A"

  alias {
    name                   = lookup(var.dns_record,"dns_name","*")
    zone_id                = lookup(var.dns_record,"zone_id","*")
    evaluate_target_health = false
  }
}

module "acmeu" {
  source             = "terraform-aws-modules/acm/aws"
  version            = "3.2.0"
  domain_name        = "${lookup(var.dns_record,"subdomain","*")}.${var.dns_zone}"
  zone_id            = data.aws_route53_zone.parentzone.zone_id

  subject_alternative_names = [
    "*.${lookup(var.dns_record,"subdomain","*")}.${var.dns_zone}"
  ]

  wait_for_validation = false
}