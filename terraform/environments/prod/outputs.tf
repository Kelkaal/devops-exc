output "app_url" {
  value = "http://${module.ec2.public_ip}:${var.app_port}"
}

output "health_check_url" {
  value = "http://${module.ec2.public_ip}:${var.app_port}/health"
}

output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${module.ec2.public_ip}"
}

output "log_group" {
  value = module.monitoring.log_group_name
}
