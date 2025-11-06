output "api_repository_url" {
  description = "Full URL of the API ECR repository."
  value       = aws_ecr_repository.api.repository_url
}

output "worker_repository_url" {
  description = "Full URL of the worker ECR repository."
  value       = aws_ecr_repository.worker.repository_url
}

output "ecs_cluster_id" {
  description = "Identifier of the ECS cluster."
  value       = aws_ecs_cluster.main.id
}

