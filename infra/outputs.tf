output "application_url" {
  description = "DNS name of the Application Load Balancer."

  value = "http://${aws_lb.main.dns_name}"
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."

  value = module.ecs.cluster_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for the ECS application."

  value = module.ecs.log_group_name
}