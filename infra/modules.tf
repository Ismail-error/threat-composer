module "ecs" {
  source = "./modules/ecs"

  app_name           = var.app_name
  task_cpu           = var.task_cpu
  task_memory        = var.task_memory
  subnet_ids         = data.aws_subnets.default.ids
  security_group_id  = aws_security_group.ecs.id
  target_group_arn   = aws_lb_target_group.main.arn
  execution_role_arn = aws_iam_role.ecs_execution.arn

  container_image = var.container_image
  aws_region      = var.aws_region

  depends_on = [
    aws_lb_listener.http
  ]
}