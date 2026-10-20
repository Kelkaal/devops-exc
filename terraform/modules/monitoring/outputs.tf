output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app.name
}

output "cpu_alarm_arn" {
  description = "ARN of the CPU alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}
