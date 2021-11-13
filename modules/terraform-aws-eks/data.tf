data "aws_eks_cluster" "cluster" {
  // fix when create_eks in eks-module is false
  count = var.enable_eks ? 1 : 0
  name  = var.enable_eks ? module.eks[0].cluster_id : local.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.enable_eks ? 1 : 0
  name  = var.enable_eks ? module.eks[0].cluster_id : local.cluster_name
}