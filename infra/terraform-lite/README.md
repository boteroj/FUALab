# Terraform Lite Infrastructure

This directory contains a minimal Terraform configuration used to provision shared infrastructure for FUALab. It establishes the foundational AWS resources required for container workloads while remaining lightweight enough for rapid iteration.

## Resources

- Two Amazon ECR repositories for the API and worker container images.
- A single Amazon ECS cluster to host service task definitions.

## Usage

1. Ensure the AWS CLI credentials are available in your environment.
2. Copy the root `.env.example` values into a Terraform variables file or export them prior to running commands.
3. Initialize the workspace: `make terraform-init`.
4. Review the deployment plan: `make terraform-plan`.

Extend this configuration with networking, task definitions, and supporting services as the platform matures.

