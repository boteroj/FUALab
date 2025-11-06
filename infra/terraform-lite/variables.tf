variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "ecr_repo_api" {
  description = "Name of the API ECR repository."
  type        = string
}

variable "ecr_repo_worker" {
  description = "Name of the worker ECR repository."
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
}

