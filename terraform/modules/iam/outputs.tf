output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}

output "alb_controller_role_arn" {
  value = aws_iam_role.alb_controller_role.arn
}
