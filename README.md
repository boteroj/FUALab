# FUALab Monorepo

FUALab is a multi-service platform composed of a public FastAPI service, a background worker, and a static frontend. Services share a Postgres database and Redis instance for caching and inter-process coordination. The repository also contains Terraform-lite infrastructure placeholders and operational documentation.

## Repository Layout

- `services/api` — FastAPI application that exposes the public HTTP interface.
- `services/worker` — Python async worker responsible for scheduled processing and Redis heartbeats.
- `services/frontend` — Static client that fetches data from the API.
- `infra/terraform-lite` — Minimal AWS placeholders.
- `infra/terraform-ecs` — Cost-conscious Terraform stack for VPC, ECS, SSM parameters, and IAM integrations.
- `ops/runbooks` — Operational procedures and troubleshooting guides.
- `ops/decisions` — Architectural decision records.
- `.github/workflows` — CI/CD automation.

## Prerequisites

- Docker 24+
- Docker Compose v2
- Python 3.11 (optional for running linters/tests without containers)
- Terraform 1.6+ (for infrastructure provisioning)
- AWS CLI v2 configured with credentials that can assume the deployment role

## Local Development

1. Copy `.env.example` to `.env` and adjust values as needed.
2. Start the full stack: `docker compose up -d --build`.
3. Inspect logs when needed: `docker compose logs -f api worker`.
4. Stop the environment: `docker compose down -v`.

### Service Endpoints

- API Docs: http://localhost:8000/docs
- Frontend: http://localhost:8080
- Postgres: localhost:5432 (defaults from `.env.example`)
- Redis: localhost:6379

## Sample API Calls

```bash
# Health
curl -fsS http://localhost:8000/health

# Create an item
curl -fsS -X POST http://localhost:8000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Sample"}'

# List items
curl -fsS http://localhost:8000/api/items
```

## Continuous Integration

- `api-ci.yml` runs on pushes/PRs to `main`.
- Tests execute with SQLite by overriding `FUALAB_DATABASE_URL` so no external services are required.
- Linting and build validation are covered by `ci.yml`.

## Continuous Delivery

- `cd-build.yml`: builds and pushes `services/api` and `services/worker` images to Amazon ECR tagged `main-${GITHUB_SHA}` using GitHub OIDC.
- `cd-deploy.yml`: triggered after a successful build; assumes the Terraform deployment role, applies the stack in `infra/terraform-ecs` with `dev.tfvars`, resolves the public IP of the API task, and performs a `/health` smoke test.

## Infrastructure Bootstrap

1. Configure AWS credentials and export `AWS_ROLE_TO_ASSUME`, `AWS_ACCOUNT_ID`, and `AWS_REGION` secrets in GitHub.
2. Review and edit `infra/terraform-ecs/dev.tfvars` with environment-specific values.
3. For manual provisioning:
   ```bash
   cd infra/terraform-ecs
   terraform init
   terraform plan -var-file=dev.tfvars
   terraform apply -var-file=dev.tfvars
   ```
4. Terraform creates or reuses a VPC, provisions public subnets, ECR repos, ECS cluster/services, security groups, and SSM parameters containing `FUALAB_DATABASE_URL`. Database connectivity is expected to target an existing Postgres endpoint supplied through variables.

## Smoke Tests

- Local: `curl -fsS http://localhost:8000/health`
- After deployment: retrieve the API task public IP via `aws ecs list-tasks`/`describe-tasks`, then `curl -fsS http://<public_ip>:8000/health`
- Worker heartbeat: check Redis key `fualab:worker:heartbeat` using the runbook in `ops/runbooks/worker-heartbeat.md`.

## Deliverables Checklist

- [x] Multi-service monorepo (`api`, `worker`, `frontend`) sharing Postgres and Redis
- [x] Docker Compose for local development with `.env.example`
- [x] Persistent `/api/items` endpoints backed by Postgres via SQLAlchemy 2.0 and Pydantic v2
- [x] Alembic migrations and Docker entrypoint applying `upgrade head`
- [x] Pytest suite covering health and item flows using SQLite in CI
- [x] CI/CD pipelines (build, deploy) using GitHub Actions with OIDC
- [x] Terraform IaC for AWS: VPC, ECR, ECS (API + worker), SSM, security, and GitHub OIDC role
- [x] Runbooks and ADR documenting operations and decisions

## Development Notes

- The worker emits a heartbeat to Redis on the key `fualab:worker:heartbeat`.
- FastAPI configuration and worker connections derive from environment variables prefixed with `FUALAB_`.
- Terraform modules are kept inline for clarity; refactor into reusable modules as requirements grow.

## License

This project is provided as-is for demonstration and internal development purposes.

## Learnings from AI-Assisted Development

This project was built using an iterative workflow assisted by AI tools, primarily Cursor.  
Several key observations emerged during development:

- **Rapid Iteration:** Using AI suggestions accelerated the implementation of FastAPI, SQLAlchemy, Alembic, and ECS-related Terraform by providing structured boilerplate and guided corrections.
- **Feedback Through CI:** Test failures (especially those involving database URLs and Alembic migrations) acted as precise feedback loops. We used AI to interpret error traces and apply targeted fixes without overcorrecting the design.
- **Refinement of Infrastructure:** Initial Terraform included high-cost resources (NAT Gateway, private subnets, ALB). Through iteration and guided reasoning, the design was reduced to public ECS tasks with SSM parameters, decreasing operational cost while meeting functional requirements.
- **Separation of Environments:** AI assistance helped enforce clear separation between local development (Docker Compose + Postgres), CI execution (SQLite), and AWS tasks (SSM-injected database URLs).
- **Documentation First:** Each architectural decision was documented in `DECISIONS.md` and `RUNBOOK.md` as it was made, ensuring that the reasoning behind the system remains traceable and maintainable.

AI-assisted development worked best when used as a collaborator: proposing structures, surfacing alternatives, and refining solutions incrementally based on real execution results.

## Live Demo (temporary)
Public demo (EC2): http://52.54.146.36:8081/  
Note: this IP is temporary and may change. The frontend proxies `/api/*` to the FastAPI service.
EOF
