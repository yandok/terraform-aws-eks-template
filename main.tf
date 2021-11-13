# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"
  name    = "${var.project}-${terraform.workspace}-vpc"
  cidr    = var.vpc_cidr
  azs                 = var.vpc_azs
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_vpn_gateway = false
  create_database_subnet_group = false
}

# DNS
module "dns-record-eks" {
  source = "./modules/terraform-aws-dns-alias-record"
  dns_zone = var.dns_zone
  dns_record = {
    subdomain: var.subdomain
    dns_name: module.lb.dns_name
    zone_id = module.lb.zone_id
  }
}

# LB
module "lb" {
  source = "./modules/terraform-aws-load-balancer"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  project = var.project
  certificate_arn = module.dns-record-eks.acm_certificate_arn
}

# EKS
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
}
