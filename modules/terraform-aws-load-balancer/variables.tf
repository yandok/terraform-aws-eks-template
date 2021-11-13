variable "project" {
  type = string
  description = "project name the LB belongs to"
}

variable "vpc_id" {
  type = string
  description = "VPC ID the LB should be attached to"
}

variable "public_subnets" {
  type = list(string)
  description = "public subnet IDs the LB should be available in"
}

variable "certificate_arn" {
  type = string
  description = "ARN of the ACM certificate, the https-listener of the LB should use"
}