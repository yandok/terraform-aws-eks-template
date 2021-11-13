<!-- BEGIN_TF_DOCS -->
# terraform-aws-dns-alias-record

This module is used for creating an alias DNS record for a subdomain.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.65.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acmeu"></a> [acmeu](#module\_acmeu) | terraform-aws-modules/acm/aws | 3.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_record"></a> [dns\_record](#input\_dns\_record) | DNS record to create | `object({ subdomain: string, dns_name: string, zone_id: string })` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | Zone, where DNS records get created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | ACM certificate ARN of the for the DNS-record created TLS-certificate |



Usage Example
---
**NOTE**

---
```hcl
module "dns-record-eks" {
  source = "./modules/terraform-aws-dns-alias-record"
  dns_zone = var.dns_zone
  dns_record = {
    subdomain: var.subdomain
    dns_name: module.lb.dns_name
    zone_id = module.lb.zone_id
  }
}
```
<!-- END_TF_DOCS -->