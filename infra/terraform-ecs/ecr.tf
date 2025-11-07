resource "aws_ecr_repository" "api" {
  name                 = "fualab/api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-api-repo"
  })
}

resource "aws_ecr_repository" "worker" {
  name                 = "fualab/worker"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-worker-repo"
  })
}

