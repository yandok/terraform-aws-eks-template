<!-- BEGIN_TF_DOCS -->
# terraform-aws-load-balancer

This module is used for creating an application load balancer with HTTPS-listener
 * HTTP - listener redirects to HTTPS
 * HTTPS - listeners default-action is to return a fixed response

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb-external"></a> [alb-external](#module\_alb-external) | terraform-aws-modules/alb/aws | 6.3.0 |
| <a name="module_security_group_alb_external"></a> [security\_group\_alb\_external](#module\_security\_group\_alb\_external) | terraform-aws-modules/security-group/aws | 4.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | ARN of the ACM certificate, the https-listener of the LB should use | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | project name the LB belongs to | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subnet IDs the LB should be available in | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID the LB should be attached to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of LB |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | ARN of https-listener of LB |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | security group ID from LB |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | zone ID of LB |



Usage Example
---
**NOTE**

---
```hcl
module "lb" {
  source = "./modules/terraform-aws-load-balancer"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  project = var.project
  certificate_arn = module.dns-record-eks.acm_certificate_arn
}
```
<!-- END_TF_DOCS -->