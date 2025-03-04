provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"  # Use latest version

  name = "eks-fargate-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  # REMOVE deprecated arguments
  # enable_classiclink = false
  # enable_classiclink_dns_support = false
}

# Create EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-fargate-cluster"
  cluster_version = "1.29"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets

  enable_irsa = true # Enable IAM roles for service accounts

  fargate_profiles = {
    default = {
      name = "fargate-profile"
      selectors = [{
        namespace = "default"
      }]
    }
  }
}

# Output Cluster Information
output "eks_cluster_name" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_fargate_profiles_debug" {
  value = module.eks.fargate_profiles
}