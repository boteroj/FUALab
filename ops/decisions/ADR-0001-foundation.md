# ADR-0001: Monorepo Foundation

## Status

Accepted — 2025-11-06

## Context

FUALab comprises multiple services that share infrastructure and must evolve together. Coordinating API changes, worker updates, and frontend adaptations is simplest when versioned atomically. The PRD mandates shared tooling, environment parity, and consistent deployment automation.

## Decision

We maintain all application services, infrastructure definitions, and operational documentation in a single monorepo. Shared assets (environment templates, Docker Compose, CI pipelines) live at the repository root. Service-specific code resides under `services/`, and infrastructure lives under `infra/`.

## Consequences

- **Positive:** Simplified dependency management, one source of truth for environment configuration, unified CI/CD pipelines, and streamlined cross-service refactors.
- **Negative:** Larger repository size over time and the need for careful coordination to avoid heavy-weight pull requests.
- **Mitigation:** Enforce clear directory ownership, maintain focused CI jobs per service, and revisit the architecture when scale demands further decomposition.

