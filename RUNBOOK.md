# FUALab Runbook

## Deployments
- Triggered automatically via `CD Deploy` workflow after image build.
- For manual redeploy, re-run the workflow in GitHub Actions with the latest successful build.
- Monitor the `Terraform Apply` step for infrastructure changes and verify the smoke test passes.

## Rollback
- Re-run `CD Build` and `CD Deploy` for the previous known-good commit.
- If an immediate rollback is required, scale API and worker services to zero via the AWS console or CLI, then redeploy.

## Secret Rotation
- Update SSM parameter `/fualab/<env>/DATABASE_URL` (and related credentials if changed).
- Re-run the `CD Deploy` workflow or restart the ECS services so new secrets are fetched.

## Logs and Monitoring
- API logs: CloudWatch log group `/aws/ecs/<env>-api`.
- Worker logs: CloudWatch log group `/aws/ecs/<env>-worker`.
- Postgres monitoring: RDS performance insights when enabled; basic metrics in CloudWatch.

## Common Issues
- **Failed smoke test**: Validate ALB target health and ensure migrations succeeded (`alembic` logs in CloudWatch).
- **Database connectivity errors**: Confirm SSM parameter values and RDS security group rules.
- **Worker heartbeat missing**: Use `ops/runbooks/worker-heartbeat.md` to check Redis and container health.

## Database Migration Notes
- Migrations run automatically during container startup (`alembic upgrade head`).
- For manual execution: `docker compose run --rm api alembic upgrade head` locally or `aws ecs execute-command` in production.
- Keep Alembic versions in `services/api/app/migrations/versions/` under version control.

