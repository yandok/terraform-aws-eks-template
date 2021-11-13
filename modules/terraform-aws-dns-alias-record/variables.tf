variable "dns_zone" {
  type = string
  description = "Zone, where DNS records get created"
}

variable "dns_record" {
  type = object({ subdomain: string, dns_name: string, zone_id: string })
  description = "DNS record to create"
}
