# General
aws_accountnumber = "<your-aws-account-number>"
environment = "dev"
project     = "eks-template"

# VPC
vpc_cidr        = "172.35.0.0/16"
aws_region      = "eu-west-1"
vpc_azs         = ["eu-west-1a", "eu-west-1b"]
private_subnets = ["172.35.1.0/24", "172.35.2.0/24"]
public_subnets  = ["172.35.101.0/24", "172.35.102.0/24"]

# DNS
dns_zone = "<your-public-dns-zone>"
subdomain = "eks-template"

# EKS
enable_eks = true
install_nginx_ingress = true
install_kubernetes_dashboard = true
eks_version = "1.19"
# ami_id must match for the kubernetes version specified in eks_version variable
ami_id = "ami-05fbcac3cb8054b00" // amazon-eks-node-1.19-v20211013
eks_general_workers_override_instance_types                  = ["m5.large", "m5a.large", "m4.large"]
eks_general_workers_asg_min_size                             = 0
eks_general_workers_asg_desired_capacity                     = 1
eks_general_workers_on_demand_base_capacity                  = 0
eks_general_workers_on_demand_percentage_above_base_capacity = 0
eks_general_workers_asg_max_size                             = 1
eks_general_workers_spot_instance_pools                      = 3
eks_map_users = []
eks_map_roles = []
eks_map_accounts = []
