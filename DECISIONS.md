# Architecture Decisions

## SQLite in CI
- **Context:** GitHub Actions cannot easily provision managed Postgres instances for every pipeline run.
- **Decision:** Override `FUALAB_DATABASE_URL` to `sqlite:///./tests_api.db` during CI so tests run locally in-memory.
- **Outcome:** Fast feedback, deterministic tests, minimal infrastructure dependencies. Production remains on Postgres.

## ECS Fargate
- **Context:** The platform needs container orchestration with minimal operational overhead.
- **Decision:** Use AWS ECS on Fargate rather than self-managed EC2 hosts.
- **Outcome:** Serverless compute, automatic patching, lower maintenance burden, predictable pricing.

## Postgres on RDS (db.t4g.micro)
- **Context:** Persistent relational storage is required; budgets favor a starter tier.
- **Decision:** Provision Amazon RDS Postgres using `db.t4g.micro`.
- **Outcome:** Managed backups, automated updates, and a path to scale later while keeping initial costs low.

## Parameter Storage via AWS SSM
- **Context:** Services require secrets (database credentials/URL) without hardcoding.
- **Decision:** Store configuration as SecureString parameters in AWS Systems Manager Parameter Store.
- **Outcome:** Centralized secret management, granular IAM permissions, straightforward ECS integration.

## GitHub Actions OIDC
- **Context:** CI/CD needs AWS access without long-lived credentials.
- **Decision:** Configure GitHub Actions OpenID Connect to assume an AWS IAM role during workflows.
- **Outcome:** Eliminates static AWS keys, enforces least privilege, supports auditability.

## Migrations on Startup
- **Context:** Early iterations mandate schema drift protection without a dedicated migration pipeline.
- **Decision:** Launch containers with `alembic upgrade head && uvicorn ...` so migrations run before serving traffic.
- **Outcome:** Ensures schema alignment; future work can offload to CI/CD once deployment matures.

