<!-- BEGIN_TF_DOCS -->
# terraform-aws-eks

This module is used for creating an EKS cluster
 * Control-Plane API is public accessible
 * worker-nodes are in private subnets
 * worker-nodes are managed by an autoscaling group and use mixed-instance-policy (can consist of on-demand and spot-instances)
 * module creates a listener-rule to a given listener-ARN of a load balancer
 * module conditionally installs nginx ingress controller and kubernetes dashboard

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.65.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.6.1 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 17.23.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID to use for the worker nodes (version must match with the Kubernetes version of the control plane | `string` | n/a | yes |
| <a name="input_eks_general_workers_asg_desired_capacity"></a> [eks\_general\_workers\_asg\_desired\_capacity](#input\_eks\_general\_workers\_asg\_desired\_capacity) | desired number of nodes in the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_asg_max_size"></a> [eks\_general\_workers\_asg\_max\_size](#input\_eks\_general\_workers\_asg\_max\_size) | maximum number of nodes in the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_asg_min_size"></a> [eks\_general\_workers\_asg\_min\_size](#input\_eks\_general\_workers\_asg\_min\_size) | minimum size of the autoscaling group | `number` | n/a | yes |
| <a name="input_eks_general_workers_on_demand_base_capacity"></a> [eks\_general\_workers\_on\_demand\_base\_capacity](#input\_eks\_general\_workers\_on\_demand\_base\_capacity) | how much percent should be on-demand instances | `number` | n/a | yes |
| <a name="input_eks_general_workers_on_demand_percentage_above_base_capacity"></a> [eks\_general\_workers\_on\_demand\_percentage\_above\_base\_capacity](#input\_eks\_general\_workers\_on\_demand\_percentage\_above\_base\_capacity) | how much percent should be on-demand instances when the autoscaling group is scaled | `number` | n/a | yes |
| <a name="input_eks_general_workers_override_instance_types"></a> [eks\_general\_workers\_override\_instance\_types](#input\_eks\_general\_workers\_override\_instance\_types) | instance types that should be taken into account for the spot instance pool | `list(string)` | n/a | yes |
| <a name="input_eks_general_workers_spot_instance_pools"></a> [eks\_general\_workers\_spot\_instance\_pools](#input\_eks\_general\_workers\_spot\_instance\_pools) | instance type in the spot instance pool | `number` | n/a | yes |
| <a name="input_eks_map_accounts"></a> [eks\_map\_accounts](#input\_eks\_map\_accounts) | additional AWS account numbers to add to the aws-auth configmap. | `list(string)` | n/a | yes |
| <a name="input_eks_map_roles"></a> [eks\_map\_roles](#input\_eks\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_eks_map_users"></a> [eks\_map\_users](#input\_eks\_map\_users) | Additional IAM users to add to the aws-auth configmap. | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Kubernetes version to use in EKS Cluster | `string` | n/a | yes |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | whether to create EKS cluster or not | `bool` | n/a | yes |
| <a name="input_ingress_from_security_group_id"></a> [ingress\_from\_security\_group\_id](#input\_ingress\_from\_security\_group\_id) | security group ID from which ingress traffic to worker nodes is allwed | `string` | n/a | yes |
| <a name="input_install_kubernetes_dashboard"></a> [install\_kubernetes\_dashboard](#input\_install\_kubernetes\_dashboard) | wheter to install kubernetes dashboard or not | `bool` | n/a | yes |
| <a name="input_install_nginx_ingress"></a> [install\_nginx\_ingress](#input\_install\_nginx\_ingress) | whether to install nginx ingress controller or not | `bool` | n/a | yes |
| <a name="input_lb_listener_rule_arn"></a> [lb\_listener\_rule\_arn](#input\_lb\_listener\_rule\_arn) | ARN of the LB listener for attaching a listener-rule | `string` | n/a | yes |
| <a name="input_lb_listener_rule_host"></a> [lb\_listener\_rule\_host](#input\_lb\_listener\_rule\_host) | Host for specifying which traffic should be proxied to worker nodes | `string` | n/a | yes |
| <a name="input_lb_listener_rule_priority"></a> [lb\_listener\_rule\_priority](#input\_lb\_listener\_rule\_priority) | priority of the LB listener rule created | `number` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | IDs of private subnets, the worker nodes should be placed in | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | project name the EKS cluster belongs to | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID the EKS cluster should be attached to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | cluster ca certificate to authenticate at the API server |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | name of the EKS cluster |
| <a name="output_cluster_oidc_issuer_url"></a> [cluster\_oidc\_issuer\_url](#output\_cluster\_oidc\_issuer\_url) | OIDC issuer URL of the cluster |
| <a name="output_cluster_oidc_issuer_url_short"></a> [cluster\_oidc\_issuer\_url\_short](#output\_cluster\_oidc\_issuer\_url\_short) | short version of OIDC issuer URL of the cluster |
| <a name="output_host"></a> [host](#output\_host) | host to authenticate at the API server |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN of the cluster |
| <a name="output_token"></a> [token](#output\_token) | token to authenticate at the API server |



Usage Example
---
**NOTE**

---
```hcl
module "eks" {
  source = "./modules/terraform-aws-eks"
  project = var.project
  eks_version = var.eks_version
  ami_id = var.ami_id
  enable_eks = var.enable_eks
  install_nginx_ingress = var.install_nginx_ingress
  install_kubernetes_dashboard = var.install_kubernetes_dashboard
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  ingress_from_security_group_id = module.lb.security_group_id
  lb_listener_rule_arn = module.lb.https_listener_arn
  lb_listener_rule_host = "${var.subdomain}.${var.dns_zone}"
  lb_listener_rule_priority = 99
  eks_general_workers_asg_desired_capacity = var.eks_general_workers_asg_desired_capacity
  eks_general_workers_asg_max_size = var.eks_general_workers_asg_max_size
  eks_general_workers_asg_min_size = var.eks_general_workers_asg_min_size
  eks_general_workers_on_demand_base_capacity = var.eks_general_workers_on_demand_base_capacity
  eks_general_workers_on_demand_percentage_above_base_capacity = var.eks_general_workers_on_demand_percentage_above_base_capacity
  eks_general_workers_override_instance_types = var.eks_general_workers_override_instance_types
  eks_general_workers_spot_instance_pools = var.eks_general_workers_spot_instance_pools
  eks_map_accounts = []
  eks_map_roles = []
  eks_map_users = []
  key_name = var.key_name
}
```
<!-- END_TF_DOCS -->