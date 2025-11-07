locals {
  ssm_kms_key_id_effective = var.ssm_kms_key_id != "" ? var.ssm_kms_key_id : null
}

resource "aws_ssm_parameter" "database_url" {
  name        = format("/fualab/%s/DATABASE_URL", var.environment)
  description = "Database connection string for ${var.environment}"
  type        = "SecureString"
  value       = format(
    "postgresql://%s:%s@localhost:5432/%s",
    var.db_username,
    var.db_password,
    var.db_name,
  )
  overwrite = true
  key_id    = local.ssm_kms_key_id_effective

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-database-url"
  })
}

