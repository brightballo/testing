# provider "aws" {
#   region = var.region
# }

module "eks" {
  source  = "WesleyCharlesBlake/eks/aws"
  version = "3.0.5"
  aws-region = var.region
}