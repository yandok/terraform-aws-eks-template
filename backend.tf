terraform {
  backend "s3" {
    bucket               = "<your-bucket-name>"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "eks-template"
    region               = "eu-west-1"
  }
}