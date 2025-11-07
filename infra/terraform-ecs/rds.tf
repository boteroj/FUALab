resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Database access"
  vpc_id      = local.vpc_id_effective

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rds-sg"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnets"
  subnet_ids = local.private_subnet_ids_effective

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-subnets"
  })
}

resource "aws_db_instance" "this" {
  identifier              = "${local.name_prefix}-postgres"
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_allocated_storage * 2
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "15.5"
  instance_class          = "db.t4g.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention
  deletion_protection     = var.enable_deletion_protection
  skip_final_snapshot     = !var.enable_deletion_protection
  apply_immediately       = true
  performance_insights_enabled = true
  auto_minor_version_upgrade   = true
  iam_database_authentication_enabled = false
  publicly_accessible               = false

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-postgres"
  })
}

