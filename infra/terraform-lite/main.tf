terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  project = "fualab"
}

# Placeholder ECR repositories for API and Worker images.
resource "aws_ecr_repository" "api" {
  name                 = var.ecr_repo_api
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "worker" {
  name                 = var.ecr_repo_worker
  image_tag_mutability = "MUTABLE"
}

# Placeholder ECS cluster definition.
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

