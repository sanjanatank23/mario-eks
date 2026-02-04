output "node_role_arn" {
  value = aws_iam_role.node_role.arn
}


output "alb_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller (IRSA)"
  value       = aws_iam_role.alb_controller_role.arn
}
