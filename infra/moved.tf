moved {
  from = aws_ecs_cluster.main
  to   = module.ecs.aws_ecs_cluster.main
}

moved {
  from = aws_cloudwatch_log_group.main
  to   = module.ecs.aws_cloudwatch_log_group.main
}

moved {
  from = aws_ecs_task_definition.main
  to   = module.ecs.aws_ecs_task_definition.main
}

moved {
  from = aws_ecs_service.main
  to   = module.ecs.aws_ecs_service.main
}