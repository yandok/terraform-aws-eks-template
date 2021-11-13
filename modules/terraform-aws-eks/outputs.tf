output "cluster_oidc_issuer_url_short" {
  value = local.cluster_oidc_issuer_url_short
  description = "short version of OIDC issuer URL of the cluster"
}

output "cluster_oidc_issuer_url" {
  value = var.enable_eks ? module.eks[0].cluster_oidc_issuer_url : ""
  description = "OIDC issuer URL of the cluster"
}

output "oidc_provider_arn" {
  value = var.enable_eks ? module.eks[0].oidc_provider_arn : ""
  description = "OIDC provider ARN of the cluster"
}

output "host" {
  value = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  description = "host to authenticate at the API server"
}

output "cluster_ca_certificate" {
  value = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  description = "cluster ca certificate to authenticate at the API server"
}

output "token" {
  value = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  description = "token to authenticate at the API server"
}

output "cluster_name" {
  value = local.cluster_name
  description = "name of the EKS cluster"
}