# GENERAL
variable "aws_accountnumber" {
  type        = string
  description = "AWS account number"
}

# Tags
variable "environment" {
  type        = string
  description = "environment name"
}

variable "project" {
  type        = string
  description = "project name"
}

# VPC
# VPC
variable "vpc_cidr" {
  type        = string
  description = "CIDR of VPC"
}

variable "aws_region" {
  type        = string
  description = "region to deploy in"
}

variable "vpc_azs" {
  type        = list(string)
  description = "AZs in use within region"
}

variable "private_subnets" {
  type        = list(string)
  description = "private subnet CIDRs"
}

variable "public_subnets" {
  type        = list(string)
  description = "public subnet CIDRs"
}

# DNS
variable "dns_zone" {
  type = string
  description = "parent-domain, where subdomain DNS record gets created"
}

variable "subdomain" {
  type = string
  description = "subdomain for which DNS should be created"
}

# EKS
variable "enable_eks" {
  type = bool
  description = "whether to create EKS cluster or not"
}

variable "eks_version" {
  description = "Kubernetes version to use in EKS Cluster"
  type = string
}

variable "install_nginx_ingress" {
  type = bool
  description = "whether to install nginx ingress controller or not"
}

variable "install_kubernetes_dashboard" {
  type = bool
  description = "wheter to install kubernetes dashboard or not"
}

variable "ami_id" {
  type = string
  description = "AMI ID to use for the worker nodes (version must match with the Kubernetes version of the control plane"
}

variable "eks_map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
}

variable "eks_map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "eks_map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "eks_general_workers_override_instance_types" {
  type = list(string)
  description = "instance types that should be taken into account for the spot instance pool"
}

variable "eks_general_workers_asg_min_size" {
  type = number
  description = "minimum size of the autoscaling group"
}

variable "eks_general_workers_asg_desired_capacity" {
  type = number
  description = "desired number of nodes in the autoscaling group"
}

variable "eks_general_workers_on_demand_base_capacity" {
  type = number
  description = "how much percent should be on-demand instances"
}

variable "eks_general_workers_on_demand_percentage_above_base_capacity" {
  type = number
  description = "how much percent should be on-demand instances when the autoscaling group is scaled"
}

variable "eks_general_workers_asg_max_size" {
  type = number
  description = "maximum number of nodes in the autoscaling group"
}

variable "eks_general_workers_spot_instance_pools" {
  type = number
  description = "instance type in the spot instance pool"
}