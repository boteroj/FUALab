output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "api_service_name" {
  description = "Name of the ECS service running the API."
  value       = aws_ecs_service.api.name
}

output "worker_service_name" {
  description = "Name of the ECS service running the worker."
  value       = aws_ecs_service.worker.name
}

output "api_repository_url" {
  description = "ECR repository URL for the API image."
  value       = aws_ecr_repository.api.repository_url
}

output "worker_repository_url" {
  description = "ECR repository URL for the worker image."
  value       = aws_ecr_repository.worker.repository_url
}

output "github_actions_role_arn" {
  description = "IAM role ARN assumable by GitHub Actions for deployments."
  value       = aws_iam_role.github_actions.arn
}

