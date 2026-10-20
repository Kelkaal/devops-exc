variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name — prefix for all AWS resource names"
  type        = string
  default     = "devops-challenge"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "app_port" {
  description = "Port the containerised application listens on"
  type        = number
  default     = 3000
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_ami" {
  description = "Amazon Linux 2023 AMI — update if changing region"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "ssh_public_key" {
  description = "Contents of your ~/.ssh/id_rsa.pub"
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "Full Docker image URI (e.g. ghcr.io/username/repo:latest)"
  type        = string
}
