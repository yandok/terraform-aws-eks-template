# terraform-aws-eks-template

this is a demo repository for bootstrapping a simple cloud infrastructure with a public accessible demo-application running on an EKS cluster


Generating Terraform Docs:
  * `./generate-terraform-docs.sh`

## Prerequisites
  * AWS account (`aws_accountnumber`-variable)
  * existing public DNS zone in your AWS account (`dns_zone`-variable)
  * S3 bucket for storing the Terraform state (`bucket` - value in s3 backend definition in `backend.tf`)
## Usage
  * initialize Terraform working directory:
    * `terraform init`
  * create new Terraform workspace "dev":
    * `terraform workspace new dev`
  * set variables in `envs/dev.tfvars`
 
```yaml
# General
aws_accountnumber = "<your AWS account number>"
environment = "dev"
project     = "eks-template"
aws_region  = "eu-west-1"

# DNS
dns_zone  = "<your parent DNS zone>"
subdomain = "<descired subdomain>"
```
  * plan infrastructure: `terraform plan -var-file envs/dev.tfvars`
  * provision infrastructure `terraform apply -var-file envs/dev.tfvars`
  * after provisioning was done access the Kubernetes-dashboard at `https://<subdomain>.<dns_zone>`

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | =0.14.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.62.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.3.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >=3.1.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-record-eks"></a> [dns-record-eks](#module\_dns-record-eks) | ./modules/terraform-aws-dns-alias-record | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ./modules/terraform-aws-eks | n/a |
| <a name="module_lb"></a> [lb](#module\_lb) | ./modules/terraform-aws-load-balancer | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.78.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for the worker nodes (version must match with the Kubernetes version of the control plane | `string` | n/a | yes |
| <a name="input_aws_accountnumber"></a> [aws\_accountnumber](#input\_aws\_accountnumber) | AWS account number | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | region to deploy in | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | parent-domain, where subdomain DNS record gets created | `string` | n/a | yes |
| <a name="input_eks_general_workers_asg_desired_capacity"></a> [eks\_general\_workers\_asg\_desired\_capacity](#input\_eks\_general\_workers\_asg\_desired\_capacity) | desired number of nodes in the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_asg_max_size"></a> [eks\_general\_workers\_asg\_max\_size](#input\_eks\_general\_workers\_asg\_max\_size) | maximum number of nodes in the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_asg_min_size"></a> [eks\_general\_workers\_asg\_min\_size](#input\_eks\_general\_workers\_asg\_min\_size) | minimum size of the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_on_demand_base_capacity"></a> [eks\_general\_workers\_on\_demand\_base\_capacity](#input\_eks\_general\_workers\_on\_demand\_base\_capacity) | how much percent should be on-demand instances | `number` | n/a | yes |
| <a name="input_eks_general_workers_on_demand_percentage_above_base_capacity"></a> [eks\_general\_workers\_on\_demand\_percentage\_above\_base\_capacity](#input\_eks\_general\_workers\_on\_demand\_percentage\_above\_base\_capacity) | how much percent should be on-demand instances when the autoscaling group is scaled | `number` | n/a | yes |
| <a name="input_eks_general_workers_override_instance_types"></a> [eks\_general\_workers\_override\_instance\_types](#input\_eks\_general\_workers\_override\_instance\_types) | instance types that should be taken into account for the spot instance pool | `list(string)` | n/a | yes |
| <a name="input_eks_general_workers_spot_instance_pools"></a> [eks\_general\_workers\_spot\_instance\_pools](#input\_eks\_general\_workers\_spot\_instance\_pools) | instance type in the spot instance pool | `number` | n/a | yes |
| <a name="input_eks_map_accounts"></a> [eks\_map\_accounts](#input\_eks\_map\_accounts) | Additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | n/a | yes |
| <a name="input_eks_map_roles"></a> [eks\_map\_roles](#input\_eks\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_eks_map_users"></a> [eks\_map\_users](#input\_eks\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Kubernetes version to use in EKS Cluster | `string` | n/a | yes |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | whether to create EKS cluster or not | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment name | `string` | n/a | yes |
| <a name="input_install_kubernetes_dashboard"></a> [install\_kubernetes\_dashboard](#input\_install\_kubernetes\_dashboard) | wheter to install kubernetes dashboard or not | `bool` | n/a | yes |
| <a name="input_install_nginx_ingress"></a> [install\_nginx\_ingress](#input\_install\_nginx\_ingress) | whether to install nginx ingress controller or not | `bool` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | private subnet CIDRs | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | project name | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | public subnet CIDRs | `list(string)` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | subdomain for which DNS should be created | `string` | n/a | yes |
| <a name="input_vpc_azs"></a> [vpc\_azs](#input\_vpc\_azs) | AZs in use within region | `list(string)` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR of VPC | `string` | n/a | yes |

## Outputs

No outputs.


<!-- END_TF_DOCS -->