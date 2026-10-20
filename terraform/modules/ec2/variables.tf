variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID — passed in from the vpc module output"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID — passed in from the vpc module output"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Port the containerised app listens on"
  type        = number
  default     = 3000
}

variable "ssh_public_key" {
  description = "SSH public key content for EC2 access"
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "Full Docker image URI to pull and run on the instance"
  type        = string
}
