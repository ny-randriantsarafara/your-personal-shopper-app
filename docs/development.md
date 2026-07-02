# Development

## Prerequisites

- Node.js (v20+).
- pnpm — pinned via `packageManager` in the root `package.json`; enable with `corepack enable`.
- Flutter and Dart (stable channel).
- PostgreSQL for running the API against a real database.

## Install

```bash
pnpm install
```

This installs dependencies for the JavaScript/TypeScript workspace (`apps/landing`, `apps/api`, `packages/*`). The Flutter apps fetch their own dependencies via `flutter pub get`.

## Common commands

JavaScript/TypeScript (run from the repo root):

```bash
pnpm -r build      # build all packages and JS/TS apps
pnpm -r lint       # lint/type-check all packages
pnpm -r test       # run all package tests
pnpm dev:landing   # run the landing site
pnpm dev:api       # run the API in watch mode
```

Flutter apps:

```bash
cd apps/customer && flutter test && flutter build web
cd apps/admin    && flutter test && flutter build web
```

## API database

The API reads `DATABASE_URL` from `apps/api/.env` (gitignored). Copy the example and adjust:

```bash
cp apps/api/.env.example apps/api/.env
```

Validate the Prisma schema and generate the client:

```bash
pnpm --filter @personal-shopper/api exec prisma validate
pnpm --filter @personal-shopper/api exec prisma generate
```
