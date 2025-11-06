# Worker Heartbeat Runbook

## Overview

The background worker publishes a heartbeat to Redis using the key `fualab:worker:heartbeat`. The value is an ISO8601 timestamp and the key has a configurable TTL.

## Verification Steps

1. Connect to the Redis instance: `redis-cli -u $FUALAB_REDIS_URL`.
2. Check the heartbeat value: `GET fualab:worker:heartbeat`.
3. Confirm the TTL is renewing: `TTL fualab:worker:heartbeat`.

If the TTL is negative, the worker is not updating the heartbeat as expected.

## Recovery

1. Inspect the worker logs for connection or authentication errors.
2. Validate database connectivity from the worker container.
3. Restart the worker service: `docker compose restart worker`.
4. If the issue persists, redeploy the worker image and confirm new tasks register in ECS.

