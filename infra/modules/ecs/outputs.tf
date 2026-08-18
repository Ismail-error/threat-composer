output "cluster_name" {
  description = "Name of the ECS cluster."

  value = aws_ecs_cluster.main.name
}

output "log_group_name" {
  description = "CloudWatch log group name."

  value = aws_cloudwatch_log_group.main.name
}

output "service_arn" {
  description = "ARN of the ECS service."

  value = aws_ecs_service.main.arn
}
