environment            = "dev"
aws_region             = "us-east-1"
create_vpc             = true
db_username            = "fualab_dev"
db_password            = "replace-with-strong-password"
db_name                = "fualab"
api_container_image    = "123456789012.dkr.ecr.us-east-1.amazonaws.com/fualab/api:latest"
worker_container_image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/fualab/worker:latest"
alb_ingress_cidrs      = ["0.0.0.0/0"]
enable_github_oidc     = false
additional_tags = {
  Owner = "platform-team"
}

