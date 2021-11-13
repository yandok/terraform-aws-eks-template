module "lb" {
  source = "./modules/terraform-aws-load-balancer"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  project = var.project
  certificate_arn = module.dns-record-eks.acm_certificate_arn
}