.PHONY: help install dev format lint test terraform-init terraform-plan

help:
	@grep -E '^[a-zA-Z_-]+:.*?#' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?#"}; {printf "%-24s %s\n", $$1, $$2}'

install:  # Install local dependencies via uv (optional)
	@echo "Use docker-compose for containerized development. No local install steps defined."

dev:  # Run the full stack with docker-compose
	docker compose up --build

format:  # Placeholder for formatting hooks
	@echo "Formatting is managed per service."

lint:  # Placeholder for linting commands
	@echo "Linting is managed per service."

test:  # Placeholder for test suite
	@echo "Tests are managed per service."

terraform-init:  # Initialize Terraform configuration
	cd infra/terraform-lite && terraform init

terraform-plan: terraform-init  # Create Terraform plan
	cd infra/terraform-lite && terraform plan

