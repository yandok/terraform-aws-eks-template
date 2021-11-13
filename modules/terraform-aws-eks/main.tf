/**
 * # terraform-aws-eks
 *
 * This module is used for creating an EKS cluster
 *  * Control-Plane API is public accessible
 *  * worker-nodes are in private subnets
 *  * worker-nodes are managed by an autoscaling group and use mixed-instance-policy (can consist of on-demand and spot-instances)
 *  * module creates a listener-rule to a given listener-ARN of a load balancer
 *  * module conditionally installs nginx ingress controller and kubernetes dashboard
 */
locals {
  cluster_name                  = "${var.project}-${terraform.workspace}-eks"
  cluster_oidc_issuer_url_short = var.enable_eks ? substr(module.eks[0].cluster_oidc_issuer_url, 8, length(module.eks[0].cluster_oidc_issuer_url)) : ""
  workspace = terraform.workspace
  project = var.project
}

resource "aws_security_group" "eks_workers_sg" {
  count = var.enable_eks ? 1 : 0
  name        = "${var.project}-${terraform.workspace}-eks-workers-sg"
  vpc_id      = var.vpc_id
  description = "all_worker_management"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  ingress {
    protocol        = "tcp"
    from_port       = 30007
    to_port         = 30010
    security_groups = [var.ingress_from_security_group_id]
  }

  tags = {
    Name = "${var.project}-${terraform.workspace}-eks-workers-sg"
  }
}

module "eks" {
  count = var.enable_eks ? 1 : 0
  source = "terraform-aws-modules/eks/aws"
  # Pinned to a version that does not require an "aws" provider version >3.22.0
  version         = "17.23.0"
  cluster_name    = local.cluster_name
  cluster_version = var.eks_version
  //https://github.com/devopsmakers/terraform-aws-eks/issues/6
  create_eks = true
  subnets    = [var.private_subnets[0], var.private_subnets[1]]

  cluster_endpoint_public_access        = true

  ### cluster auditing
  #cluster_enabled_log_types     = ["audit", "authenticator"]
  #cluster_log_retention_in_days = 60

  ### security groups
  cluster_create_endpoint_private_access_sg_rule     = true
  cluster_create_security_group                      = true
  worker_create_cluster_primary_security_group_rules = false
  worker_create_security_group                       = true

  manage_aws_auth=true
  # enabling OIDC provider for setting up IAM roles for service accounts
  enable_irsa = true

  vpc_id = var.vpc_id

  # install spot-termination handler https://github.com/kube-aws/kube-spot-termination-notice-handler
  worker_groups_launch_template = [{
    name                     = "${var.project}-${terraform.workspace}-mixed-demand-spot"
    ami_id                   = var.ami_id
    override_instance_types  = var.eks_general_workers_override_instance_types
    root_encrypted           = true
    root_volume_size         = 100
    spot_allocation_strategy = "lowest-price" // capacity-optimized with mixed instance pools not possible
    asg_min_size             = var.eks_general_workers_asg_min_size
    // changes to desired_capacity are ignored
    // https://github.com/terraform-aws-modules/terraform-aws-eks/issues/143
    asg_desired_capacity                     = var.eks_general_workers_asg_desired_capacity
    on_demand_base_capacity                  = var.eks_general_workers_on_demand_base_capacity
    on_demand_percentage_above_base_capacity = var.eks_general_workers_on_demand_percentage_above_base_capacity
    asg_max_size                             = var.eks_general_workers_asg_max_size
    spot_instance_pools                      = var.eks_general_workers_spot_instance_pools
    kubelet_extra_args                       = "--image-pull-progress-deadline='5m' --node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"
  }]

  workers_group_defaults = {
    target_group_arns = [aws_lb_target_group.eks[0].arn]
  }

  worker_additional_security_group_ids = [aws_security_group.eks_workers_sg[0].id]
  map_roles                            = var.eks_map_roles
  map_users                            = var.eks_map_users
  map_accounts                         = var.eks_map_accounts
  write_kubeconfig                     = true
}

resource null_resource "wait-for-nodes-joined" {
  count = var.enable_eks ? 1 : 0
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/scripts/wait-for-noides-joined.sh ${var.project} ${terraform.workspace} ${var.eks_general_workers_asg_desired_capacity}"
  }
  depends_on = [module.eks[0]]
}

resource "kubernetes_service_account" "terraform-initializer" {
  count = var.enable_eks ? 1 : 0
  metadata {
    name      = "terraform-initializer"
    namespace = "kube-system"
  }

  automount_service_account_token = true
  depends_on = [null_resource.wait-for-nodes-joined[0]]
}

resource "kubernetes_cluster_role_binding" "terraform_initializer_admin" {
  count = var.enable_eks ? 1 : 0
  metadata {
    name = "${kubernetes_service_account.terraform-initializer[0].metadata[0].name}-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.terraform-initializer[0].metadata[0].name
    namespace = "kube-system"
  }
}


## attach to LB
resource "aws_lb_target_group" "eks" {
  count = var.enable_eks ? 1 : 0
  vpc_id   = var.vpc_id
  name     = "${var.project}-${terraform.workspace}-eks-tg"
  port     = 30007
  protocol = "HTTP"
}

resource "aws_lb_listener_rule" "eks_lbl_rule_private" {
  count = var.enable_eks ? 1 : 0

  listener_arn = var.lb_listener_rule_arn
  priority     = var.lb_listener_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks[0].arn
  }

  condition {
    host_header {
      values = [var.lb_listener_rule_host]
    }
  }
}

resource "kubernetes_namespace" "ingress_nginx_namespace" {
  count = (var.install_nginx_ingress && var.enable_eks) ? 1 : 0
  metadata {
    name = "ingress-nginx"
  }
  depends_on = [null_resource.wait-for-nodes-joined[0], kubernetes_cluster_role_binding.terraform_initializer_admin[0]]
}

resource "helm_release" "nginx" {
  count = (var.install_nginx_ingress && var.enable_eks) ? 1 : 0


  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.6"
  namespace  = "ingress-nginx"

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }
  set {
    name = "controller.config.use-forwarded-headers"
    value = "true"
  }
  set {
    name = "defaultBackend.enabled"
    value = "true"
  }

  set {
    name = "controller.service.nodePorts.http"
    value = "30007"
  }

  depends_on = [
    kubernetes_namespace.ingress_nginx_namespace,
  ]
}

resource "kubernetes_namespace" "kubernetes_dashboard_namespace" {
  count = (var.install_kubernetes_dashboard && var.enable_eks) ? 1 : 0
  metadata {
    name = "kubernetes-dashboard"
  }
  depends_on = [null_resource.wait-for-nodes-joined[0], kubernetes_cluster_role_binding.terraform_initializer_admin[0]]
}

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard_crb" {
  metadata {
    name = "kubernetes-dashboard"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"
  }
  depends_on = [
    kubernetes_namespace.kubernetes_dashboard_namespace,
  ]
}

resource "helm_release" "kubernetes_dashboard" {
  count = (var.install_kubernetes_dashboard && var.enable_eks) ? 1 : 0


  name       = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"
  version    = "5.0.4"
  namespace  = "kubernetes-dashboard"

  values = [
    file("${path.module}/values/values-kubernetes-dashboard.yaml")
  ]

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.hosts[0]"
    value = var.lb_listener_rule_host
  }

  depends_on = [
    kubernetes_namespace.kubernetes_dashboard_namespace,
  ]
}