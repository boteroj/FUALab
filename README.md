# FUALab Monorepo

FUALab is a multi-service platform composed of a public FastAPI service, a background worker, and a static frontend. Services share a Postgres database and Redis instance for caching and inter-process coordination. The repository also contains Terraform-lite infrastructure placeholders and operational documentation.

## Repository Layout

- `services/api` — FastAPI application that exposes the public HTTP interface.
- `services/worker` — Python async worker responsible for scheduled processing and Redis heartbeats.
- `services/frontend` — Static client that fetches data from the API.
- `infra/terraform-lite` — AWS infrastructure scaffolding for ECR and ECS.
- `ops/runbooks` — Operational procedures and troubleshooting guides.
- `ops/decisions` — Architectural decision records.
- `.github/workflows` — CI/CD pipelines.

## Getting Started

1. Copy `.env.example` to `.env` and adjust any values as needed.
2. Build and run the stack: `docker compose up --build`.
3. Access the services:
   - API: http://localhost:8000/docs
   - Frontend: http://localhost:8080
   - Postgres: localhost:5432 (default credentials in `.env.example`)
   - Redis: localhost:6379

## Development Notes

- The worker emits a heartbeat to Redis on the key `fualab:worker:heartbeat`.
- FastAPI configuration and worker connections derive from environment variables with the `FUALAB_` prefix.
- Terraform configuration is intentionally minimal and should be extended per environment.

## CI/CD

GitHub Actions workflow definitions live in `.github/workflows`. They cover linting and build checks for an initial pipeline and are intended to be expanded during implementation.

## License

This project is provided as-is for demonstration and internal development purposes.

