locals {
  config_path = "${path.module}/kubeconfig_${var.project}-${terraform.workspace}-eks"
}

provider "aws" {
  region = var.aws_region
}

# In case of not creating the cluster, this will be an incompletely configured, unused provider, which poses no problem.
provider "kubernetes" {
  host                   = module.eks.host
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  token                  = module.eks.token
}

provider "helm" {
  kubernetes {
    config_path = local.config_path
  }
}
