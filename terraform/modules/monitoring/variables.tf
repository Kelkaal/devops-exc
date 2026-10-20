variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID — from the ec2 module output"
  type        = string
}

variable "cpu_alarm_threshold" {
  description = "CPU % that triggers the alarm"
  type        = number
  default     = 80
}

variable "log_retention_days" {
  description = "Days to retain CloudWatch logs"
  type        = number
  default     = 7
}
