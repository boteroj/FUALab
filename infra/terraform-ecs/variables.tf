variable "environment" {
  description = "Deployment environment identifier (for example dev or prod)."
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
}

variable "create_vpc" {
  description = "Whether to create a new VPC. If false, provide existing VPC and subnet IDs."
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Existing VPC ID when create_vpc is false."
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "Existing public subnet IDs when create_vpc is false."
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Existing private subnet IDs when create_vpc is false."
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets when creating a VPC."
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets when creating a VPC."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use. Leave empty to auto-select."
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "Database name for the Postgres instance."
  type        = string
  default     = "fualab"
}

variable "db_username" {
  description = "Master username for the Postgres instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the Postgres instance."
  type        = string
  sensitive   = true
}

variable "db_allocated_storage" {
  description = "Allocated storage for the Postgres instance in GiB."
  type        = number
  default     = 20
}

variable "db_backup_retention" {
  description = "Backup retention days for the Postgres instance."
  type        = number
  default     = 7
}

variable "db_multi_az" {
  description = "Enable Multi-AZ for the Postgres instance."
  type        = bool
  default     = false
}

variable "api_container_image" {
  description = "Full image URI for the API service."
  type        = string
}

variable "worker_container_image" {
  description = "Full image URI for the worker service."
  type        = string
}

variable "desired_count_api" {
  description = "Desired ECS task count for the API service."
  type        = number
  default     = 2
}

variable "desired_count_worker" {
  description = "Desired ECS task count for the worker service."
  type        = number
  default     = 1
}

variable "ssm_parameter_prefix" {
  description = "Root prefix for SSM parameter names."
  type        = string
  default     = "/fualab"
}

variable "ssm_kms_key_id" {
  description = "KMS key ID for encrypting SecureString parameters."
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on stateful resources such as RDS and ALB."
  type        = bool
  default     = true
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention in days for ECS services."
  type        = number
  default     = 30
}

variable "enable_github_oidc" {
  description = "Create GitHub Actions OIDC provider and deployment role."
  type        = bool
  default     = false
}

variable "github_org" {
  description = "GitHub organisation name for OIDC trust policy."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository name for OIDC trust policy."
  type        = string
  default     = ""
}

