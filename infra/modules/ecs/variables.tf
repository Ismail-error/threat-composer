variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
}

variable "task_memory" {
  description = "Memory in MiB for the ECS task"
  type        = number
}

variable "subnet_ids" {
  description = "Subnets used by the ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role used by ECS to pull images and publish logs"
  type        = string
}

variable "container_image" {
  description = "Full container image URI used by the ECS task"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the CloudWatch Logs configuration"
  type        = string
}