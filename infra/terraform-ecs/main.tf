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
  name_prefix = "fualab-${var.environment}"
  ssm_prefix  = "${var.ssm_parameter_prefix}/${var.environment}"
  tags = merge(
    {
      Project     = "FUALab"
      Environment = var.environment
    },
    var.additional_tags,
  )
}

