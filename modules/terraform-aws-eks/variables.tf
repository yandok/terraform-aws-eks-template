variable "enable_eks" {
  type = bool
  description = "whether to create EKS cluster or not"
}

variable "install_nginx_ingress" {
  type = bool
  description = "whether to install nginx ingress controller or not"
}

variable "install_kubernetes_dashboard" {
  type = bool
  description = "wheter to install kubernetes dashboard or not"
}

variable "project" {
  type = string
  description = "project name the EKS cluster belongs to"
}

variable "vpc_id" {
  type = string
  description = "VPC ID the EKS cluster should be attached to"
}

variable "ingress_from_security_group_id" {
  type = string
  description = "security group ID from which ingress traffic to worker nodes is allwed"
}

variable "private_subnets" {
  type = list(string)
  description = "IDs of private subnets, the worker nodes should be placed in"
}

variable "lb_listener_rule_arn" {
  type = string
  description = "ARN of the LB listener for attaching a listener-rule"
}

variable "lb_listener_rule_priority" {
  type = number
  description = "priority of the LB listener rule created"
}

variable "lb_listener_rule_host" {
  type = string
  description = "Host for specifying which traffic should be proxied to worker nodes"
}


variable "eks_version" {
  type = string
  description = "Kubernetes version to use in EKS Cluster"
}

variable "ami_id" {
  type = string
  description = "AMI ID to use for the worker nodes (version must match with the Kubernetes version of the control plane"
}

variable "eks_map_accounts" {
  type        = list(string)
  description = "additional AWS account numbers to add to the aws-auth configmap."
}

variable "eks_map_roles" {
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  description = "Additional IAM roles to add to the aws-auth configmap."
}

variable "eks_map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  description = "Additional IAM users to add to the aws-auth configmap."
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