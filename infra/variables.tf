variable "aws_region" {
  description = "AWS region where infrastructure will be deployed."
  type        = string
  default     = "eu-west-2"
}

variable "app_name" {
  description = "Name of the application."
  type        = string
  default     = "threat-composer"
}

variable "task_cpu" {
  description = "CPU units allocated to the ECS task."
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.task_cpu)
    error_message = "task_cpu must be one of: 256, 512, 1024, 2048 or 4096."
  }
}

variable "task_memory" {
  description = "Memory (MiB) allocated to the ECS task."
  type        = number
  default     = 512

  validation {
    condition     = var.task_memory >= 512
    error_message = "task_memory must be at least 512 MiB."
  }
}

variable "container_image" {
  description = "Full URI of the container image stored in Amazon ECR."
  type        = string

  validation {
    condition     = length(trim(var.container_image, " ")) > 0
    error_message = "container_image cannot be empty."
  }
}