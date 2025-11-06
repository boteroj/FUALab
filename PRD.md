# PRD — Multi-Service Application with Shared Database (Concise)

This project aims to deliver a production-ready platform composed of two distinct services—a public-facing API and a background processing service—that share a central relational database. The API will provide endpoints for client applications to interact with stored data, while the background service will execute recurring or scheduled tasks that enrich or update the dataset. The system must be designed for high availability, secure data access, and ease of deployment.

The solution should be cloud-hosted (AWS), with containerized workloads and infrastructure managed as code. There should be clear separation of responsibilities between the services, with well-defined interfaces and shared schema conventions. Environments for development and production must be supported, and the deployment process should be automated via a Github Actions or CI/CD pipeline.

From a business perspective, the platform should allow rapid iteration, scalability to meet varying workloads, and operational transparency. All core functional requirements—API access, scheduled processing, secure storage, and environment parity—should be met with minimal operational overhead and clear documentation for ongoing maintenance.

*Please use AI assisted coding tools (Cursor, Codex, ) as much as possible for this exercise. We would love to hear your learnings from multiple iterations*

## Deliverables

The expected output is a fully functional GitHub repository containing:

- **All application and infrastructure code** (including backend, frontend, background workers, and Infrastructure as Code).
- **CI/CD workflows** (GitHub Actions) covering build, test, deploy, and post-deploy tasks.
- **Task and feature history** reflected in separate, meaningful commits following an iterative development approach.
- **All configuration and hidden files** necessary for reproducibility and developer tooling:
  - `.env.example` with all required environment variables for local and production builds.
  - `.vscode/` and `.cursor/` configuration directories for consistent editor and tooling setup.
  - Any relevant `.dockerignore`, `.gitignore`, `.terraform.lock.hcl`, or similar files.
- **Documentation**:
  - `README.md` with overview, setup instructions, and usage examples.
  - Supporting files (`DECISIONS.md`, `RUNBOOK.md`, etc.) for maintainability and operational guidance.

All code and resources must be organized logically, follow naming conventions, and allow the environment to be fully recreated by another developer using only the repository and documented steps.