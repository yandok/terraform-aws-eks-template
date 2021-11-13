module "dns-record-eks" {
  source = "./modules/terraform-aws-dns-alias-record"
  dns_zone = var.dns_zone
  dns_record = {
    subdomain: var.subdomain
    dns_name: module.lb.dns_name
    zone_id = module.lb.zone_id
  }
}
