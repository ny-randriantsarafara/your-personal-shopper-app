# Personal Shopper Platform

A monorepo for a multi-workspace personal shopper product: a marketing landing site, a customer app, an admin app, and a shared API, with runtime workspace branding and a unified Mobile Money payment layer.

## Repository layout

```text
your-personal-shopper-app/
  apps/
    landing/    Static marketing website (Vite)
    customer/   Flutter customer app (iOS + web first, Android-ready)
    admin/      Flutter admin app (web-first)
    api/        NestJS + Prisma + PostgreSQL API
  packages/
    domain/         Shared order statuses and permissions
    payments/       Shared payment provider codes and statuses
    design-tokens/  Cross-platform colors, radius, and motion values
  docs/
    architecture.md   App boundaries, structure, and testing strategy
    payments.md       Unified Mobile Money payment layer
    workspaces.md     Runtime workspace branding and configuration
    development.md     Local setup and common commands
    ui-migration.md    Flutter 1:1 UI migration checklist
    design-source/     Designer React/Vite export (reference only)
```

The JavaScript/TypeScript parts (`apps/landing`, `apps/api`, `packages/*`) are a pnpm workspace. The Flutter apps (`apps/customer`, `apps/admin`) are managed with the Flutter toolchain.

## Getting started

See [docs/development.md](docs/development.md) for prerequisites and commands.

## Documentation

- [Architecture](docs/architecture.md)
- [Payments](docs/payments.md)
- [Workspaces and branding](docs/workspaces.md)
- [Development](docs/development.md)
- [UI migration](docs/ui-migration.md)
