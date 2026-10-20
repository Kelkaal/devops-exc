terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
}

module "ec2" {
  source = "../../modules/ec2"

  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_id
  ami_id         = var.ec2_ami
  instance_type  = var.ec2_instance_type
  app_port       = var.app_port
  ssh_public_key = var.ssh_public_key
  docker_image   = var.docker_image
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name        = var.project_name
  environment         = var.environment
  instance_id         = module.ec2.instance_id
  cpu_alarm_threshold = 80
  log_retention_days  = 7
}
