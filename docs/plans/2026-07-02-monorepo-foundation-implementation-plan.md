# Personal Shopper Monorepo Foundation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restructure the repository into a maintainable monorepo with a landing website, Flutter customer app, Flutter web admin app, NestJS API, and shared foundations for workspace branding and Mobile Money payments.

**Architecture:** Keep four deployable apps physically separate under `apps/`, with small shared packages under `packages/`. The designer React export is preserved as a reference artifact, while customer/admin production UIs are rebuilt in Flutter with Riverpod and best-effort 1:1 fidelity. Runtime workspace branding and payment configuration belong to the API/database, not compiled source.

**Tech Stack:** Static landing website, Flutter + Riverpod, NestJS + Prisma + PostgreSQL, pnpm workspace for JavaScript/TypeScript parts, Melos or plain Flutter workspace commands for Flutter parts, REST/OpenAPI-ready API boundary.

## Documentation and Artifact Disposition

- **Temporary artifacts:** `docs/plans/2026-07-02-monorepo-architecture-design.md`, `docs/plans/2026-07-02-monorepo-foundation-implementation-plan.md`, `docs/design-source/`.
- **Promote if validated:** create or update permanent docs for app boundaries, workspace branding, payments, local setup, and per-shopper app build process. Likely targets: `README.md`, `docs/architecture.md`, `docs/payments.md`, `docs/workspaces.md`, `docs/development.md`.
- **Delete if not durable:** remove or archive temporary `docs/plans/` files after permanent docs exist. Keep `docs/design-source/README.md` only if it remains the useful pointer to the designer export; otherwise replace it with permanent design-system docs.

---

## Phase 0: Preconditions

### Task 0.1: Confirm Tooling

**Files:**
- Read: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/plans/2026-07-02-monorepo-architecture-design.md`
- Read: `/Users/nrandriantsarafara/Downloads/Personal Shopper App.zip`
- Modify: none

**Step 1: Check local tooling**

Run:

```bash
node --version
pnpm --version
flutter --version
dart --version
```

Expected:

- Node is installed.
- pnpm is installed or can be enabled with `corepack enable`.
- Flutter and Dart are installed.

**Step 2: If Flutter is missing**

Stop and install Flutter before continuing. Do not scaffold fake Flutter folders by hand.

**Step 3: Commit**

No commit. This task only verifies local prerequisites.

---

## Phase 1: Monorepo Skeleton

### Task 1.1: Create Top-Level Workspace Files

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/package.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/pnpm-workspace.yaml`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/.npmrc`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/.gitignore`

**Step 1: Write workspace metadata**

Create `package.json`:

```json
{
  "name": "personal-shopper-platform",
  "private": true,
  "version": "0.1.0",
  "packageManager": "pnpm@9.15.4",
  "scripts": {
    "build": "pnpm -r build",
    "lint": "pnpm -r lint",
    "test": "pnpm -r test",
    "dev:landing": "pnpm --filter @personal-shopper/landing dev",
    "dev:api": "pnpm --filter @personal-shopper/api start:dev"
  },
  "devDependencies": {}
}
```

Create `pnpm-workspace.yaml`:

```yaml
packages:
  - "apps/landing"
  - "apps/api"
  - "packages/*"
```

Create `.npmrc`:

```text
minimum-release-age=10080
```

Update `.gitignore` to include:

```text
node_modules/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
build/
.env
.env.local
coverage/
dist/
```

**Step 2: Validate workspace discovery**

Run:

```bash
pnpm -r list --depth -1
```

Expected: command succeeds. It may show no packages until app package files are moved/created.

**Step 3: Commit**

```bash
git add package.json pnpm-workspace.yaml .npmrc .gitignore
git commit -m "chore: initialize monorepo workspace"
```

---

### Task 1.2: Move Current Landing Page Into `apps/landing`

**Files:**
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/index.html` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/index.html`
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/app.js` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/app.js`
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/content.js` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/content.js`
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/styles.css` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/styles.css`
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/favicon.ico` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/favicon.ico`
- Move: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/assets/` to `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/assets/`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/landing/package.json`

**Step 1: Move files**

Run:

```bash
mkdir -p apps/landing
git mv index.html app.js content.js styles.css favicon.ico assets apps/landing/
```

**Step 2: Add landing package metadata**

Create `apps/landing/package.json`:

```json
{
  "name": "@personal-shopper/landing",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite --host 0.0.0.0",
    "build": "vite build",
    "preview": "vite preview --host 0.0.0.0",
    "lint": "echo \"landing lint: no linter configured yet\"",
    "test": "echo \"landing test: no tests configured yet\""
  },
  "devDependencies": {
    "vite": "6.3.5"
  }
}
```

**Step 3: Build landing**

Run:

```bash
pnpm install
pnpm --filter @personal-shopper/landing build
```

Expected: Vite builds the static landing page successfully.

**Step 4: Commit**

```bash
git add apps/landing package.json pnpm-workspace.yaml pnpm-lock.yaml
git commit -m "chore: move landing page into monorepo app"
```

---

## Phase 2: Preserve Designer Source As Reference

### Task 2.1: Extract Designer Source To `docs/design-source`

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/README.md`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/personal-shopper-app-export/`

**Step 1: Extract zip**

Run:

```bash
mkdir -p docs/design-source/personal-shopper-app-export
unzip -q /Users/nrandriantsarafara/Downloads/'Personal Shopper App.zip' -d docs/design-source/personal-shopper-app-export
```

**Step 2: Add reference README**

Create `docs/design-source/README.md`:

```markdown
# Designer Source Reference

This folder preserves the designer-provided source export for visual and behavior reference.

The exported React/Vite app is not the production runtime. Customer and admin apps are rebuilt in Flutter with best-effort 1:1 screen, interaction, and animation fidelity.

Rules:

- Do not copy shopper-specific real names into generic product source.
- Treat `src/app/App.tsx` as a prototype map for screens, states, spacing, and motion.
- Treat `src/imports/pasted_text/mvp-personal-shopper-spec.md` as product context, not final architecture authority.
```

**Step 3: Commit**

```bash
git add docs/design-source
git commit -m "docs: preserve designer source reference"
```

---

## Phase 3: Shared Domain And Payment Foundations

### Task 3.1: Create Shared Domain Package

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/domain/package.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/domain/src/index.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/domain/src/order-status.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/domain/src/permissions.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/domain/tsconfig.json`

**Step 1: Add package metadata**

Create `packages/domain/package.json`:

```json
{
  "name": "@personal-shopper/domain",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "lint": "tsc -p tsconfig.json --noEmit",
    "test": "echo \"domain test: no tests configured yet\""
  },
  "devDependencies": {
    "typescript": "5.8.3"
  }
}
```

Create `packages/domain/tsconfig.json`:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "declaration": true,
    "outDir": "dist",
    "rootDir": "src",
    "skipLibCheck": true
  },
  "include": ["src/**/*.ts"]
}
```

**Step 2: Add domain constants**

Create `packages/domain/src/order-status.ts`:

```ts
export const orderStatuses = [
  'submitted',
  'quote_available',
  'quote_accepted',
  'paid',
  'purchased',
  'warehouse_received',
  'international_transit',
  'arrived_in_madagascar',
  'delivered',
  'cancelled',
] as const;

export type OrderStatus = (typeof orderStatuses)[number];
```

Create `packages/domain/src/permissions.ts`:

```ts
export const permissions = [
  'request.create',
  'request.read',
  'request.assign',
  'quote.create',
  'quote.approve',
  'payment.read',
  'payment.verify',
  'payment.refund',
  'shipment.update',
  'workspace.manage',
  'user.manage',
] as const;

export type Permission = (typeof permissions)[number];
```

Create `packages/domain/src/index.ts`:

```ts
export * from './order-status.js';
export * from './permissions.js';
```

**Step 3: Build**

Run:

```bash
pnpm --filter @personal-shopper/domain build
```

Expected: TypeScript compiles with no errors.

**Step 4: Commit**

```bash
git add packages/domain package.json pnpm-lock.yaml
git commit -m "feat: add shared domain package"
```

---

### Task 3.2: Create Shared Payments Package

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/payments/package.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/payments/tsconfig.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/payments/src/index.ts`

**Step 1: Add package metadata**

Create `packages/payments/package.json`:

```json
{
  "name": "@personal-shopper/payments",
  "private": true,
  "version": "0.1.0",
  "type": "module",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc -p tsconfig.json",
    "lint": "tsc -p tsconfig.json --noEmit",
    "test": "echo \"payments test: no tests configured yet\""
  },
  "devDependencies": {
    "typescript": "5.8.3"
  }
}
```

Create `packages/payments/tsconfig.json` using the same structure as `packages/domain/tsconfig.json`.

**Step 2: Add payment constants**

Create `packages/payments/src/index.ts`:

```ts
export const paymentProviders = [
  'MVOLA',
  'ORANGE_MONEY',
  'AIRTEL_MONEY',
  'MANUAL_MOBILE_MONEY',
] as const;

export type PaymentProviderCode = (typeof paymentProviders)[number];

export const paymentStatuses = [
  'pending',
  'waiting_customer_action',
  'processing',
  'paid',
  'failed',
  'expired',
  'refunded',
] as const;

export type PaymentStatus = (typeof paymentStatuses)[number];
```

**Step 3: Build**

Run:

```bash
pnpm --filter @personal-shopper/payments build
```

Expected: TypeScript compiles with no errors.

**Step 4: Commit**

```bash
git add packages/payments package.json pnpm-lock.yaml
git commit -m "feat: add shared payment constants"
```

---

## Phase 4: API Skeleton

### Task 4.1: Generate NestJS API App

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/`

**Step 1: Generate app**

Run:

```bash
pnpm dlx @nestjs/cli new apps/api --package-manager pnpm --skip-git
```

If the generator tries to create a nested git repo, remove the nested `.git` immediately:

```bash
rm -rf apps/api/.git
```

**Step 2: Rename package**

Modify `apps/api/package.json`:

```json
{
  "name": "@personal-shopper/api",
  "private": true
}
```

Keep the Nest-generated scripts.

**Step 3: Run tests**

Run:

```bash
pnpm --filter @personal-shopper/api test
```

Expected: generated Nest test passes.

**Step 4: Commit**

```bash
git add apps/api package.json pnpm-workspace.yaml pnpm-lock.yaml
git commit -m "feat: scaffold api app"
```

---

### Task 4.2: Add Prisma And Workspace Models

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/prisma/schema.prisma`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/src/common/prisma/prisma.service.ts`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/package.json`

**Step 1: Install dependencies**

Run:

```bash
pnpm --filter @personal-shopper/api add @prisma/client
pnpm --filter @personal-shopper/api add -D prisma
```

**Step 2: Add Prisma schema**

Create `apps/api/prisma/schema.prisma`:

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model Workspace {
  id          String   @id @default(cuid())
  slug        String   @unique
  publicName  String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  members     WorkspaceMember[]
  settings    WorkspaceSettings?
}

model User {
  id          String   @id @default(cuid())
  phone       String?  @unique
  email       String?  @unique
  displayName String
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  memberships WorkspaceMember[]
}

model WorkspaceMember {
  id          String   @id @default(cuid())
  workspaceId String
  userId      String
  role        String
  permissions String[]
  createdAt   DateTime @default(now())

  workspace   Workspace @relation(fields: [workspaceId], references: [id])
  user        User      @relation(fields: [userId], references: [id])

  @@unique([workspaceId, userId])
}

model WorkspaceSettings {
  id                   String   @id @default(cuid())
  workspaceId          String   @unique
  logoUrl              String?
  primaryColor         String?
  supportPhone         String?
  whatsappPhone        String?
  defaultLanguage      String   @default("fr")
  enabledPaymentMethods String[]
  createdAt            DateTime @default(now())
  updatedAt            DateTime @updatedAt

  workspace            Workspace @relation(fields: [workspaceId], references: [id])
}
```

**Step 3: Add Prisma service**

Create `apps/api/src/common/prisma/prisma.service.ts`:

```ts
import { Injectable, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

**Step 4: Validate schema**

Run:

```bash
pnpm --filter @personal-shopper/api prisma validate
```

Expected: Prisma schema validates.

**Step 5: Commit**

```bash
git add apps/api package.json pnpm-lock.yaml
git commit -m "feat: add api workspace data model"
```

---

### Task 4.3: Add Payment Adapter Interface

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/src/modules/payments/providers/payment-provider.interface.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/src/modules/payments/providers/manual-mobile-money.provider.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/src/modules/payments/payment.service.ts`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/api/src/modules/payments/payment.service.spec.ts`

**Step 1: Write failing payment service test**

Create `apps/api/src/modules/payments/payment.service.spec.ts`:

```ts
import { ManualMobileMoneyProvider } from './providers/manual-mobile-money.provider';
import { PaymentService } from './payment.service';

describe('PaymentService', () => {
  it('creates a normalized manual mobile money payment intent', async () => {
    const service = new PaymentService([new ManualMobileMoneyProvider()]);

    const result = await service.createIntent({
      providerCode: 'MANUAL_MOBILE_MONEY',
      amountMGA: 125000,
      customerPhone: '+261340000000',
    });

    expect(result.status).toBe('waiting_customer_action');
    expect(result.providerCode).toBe('MANUAL_MOBILE_MONEY');
    expect(result.instructions).toContain('125000');
  });
});
```

**Step 2: Run test to verify failure**

Run:

```bash
pnpm --filter @personal-shopper/api test -- payment.service.spec.ts
```

Expected: fails because the payment service/provider do not exist yet.

**Step 3: Add provider interface**

Create `apps/api/src/modules/payments/providers/payment-provider.interface.ts`:

```ts
export type PaymentProviderCode =
  | 'MVOLA'
  | 'ORANGE_MONEY'
  | 'AIRTEL_MONEY'
  | 'MANUAL_MOBILE_MONEY';

export type PaymentIntentStatus =
  | 'pending'
  | 'waiting_customer_action'
  | 'processing'
  | 'paid'
  | 'failed'
  | 'expired'
  | 'refunded';

export interface CreatePaymentIntentInput {
  providerCode: PaymentProviderCode;
  amountMGA: number;
  customerPhone: string;
}

export interface PaymentIntentResult {
  providerCode: PaymentProviderCode;
  status: PaymentIntentStatus;
  instructions?: string;
  providerReference?: string;
  checkoutUrl?: string;
}

export interface PaymentProvider {
  providerCode: PaymentProviderCode;
  createPaymentIntent(input: CreatePaymentIntentInput): Promise<PaymentIntentResult>;
}
```

**Step 4: Add manual provider**

Create `apps/api/src/modules/payments/providers/manual-mobile-money.provider.ts`:

```ts
import {
  CreatePaymentIntentInput,
  PaymentIntentResult,
  PaymentProvider,
} from './payment-provider.interface';

export class ManualMobileMoneyProvider implements PaymentProvider {
  providerCode = 'MANUAL_MOBILE_MONEY' as const;

  async createPaymentIntent(input: CreatePaymentIntentInput): Promise<PaymentIntentResult> {
    return {
      providerCode: this.providerCode,
      status: 'waiting_customer_action',
      instructions: `Send ${input.amountMGA} MGA from ${input.customerPhone}, then wait for admin confirmation.`,
    };
  }
}
```

**Step 5: Add payment service**

Create `apps/api/src/modules/payments/payment.service.ts`:

```ts
import {
  CreatePaymentIntentInput,
  PaymentIntentResult,
  PaymentProvider,
} from './providers/payment-provider.interface';

export class PaymentService {
  constructor(private readonly providers: PaymentProvider[]) {}

  async createIntent(input: CreatePaymentIntentInput): Promise<PaymentIntentResult> {
    const provider = this.providers.find((candidate) => candidate.providerCode === input.providerCode);

    if (!provider) {
      throw new Error(`Unsupported payment provider: ${input.providerCode}`);
    }

    return provider.createPaymentIntent(input);
  }
}
```

**Step 6: Run test**

Run:

```bash
pnpm --filter @personal-shopper/api test -- payment.service.spec.ts
```

Expected: payment service test passes.

**Step 7: Commit**

```bash
git add apps/api/src/modules/payments
git commit -m "feat: add payment provider interface"
```

---

## Phase 5: Flutter Customer App

### Task 5.1: Generate Customer Flutter App

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/`

**Step 1: Generate Flutter app**

Run:

```bash
flutter create --platforms=ios,web,android apps/customer
```

**Step 2: Add Riverpod**

Run:

```bash
cd apps/customer
flutter pub add flutter_riverpod go_router
cd ../..
```

**Step 3: Replace generated counter app with app shell**

Modify `apps/customer/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(const ProviderScope(child: CustomerApp()));
}
```

Create `apps/customer/lib/app.dart`:

```dart
import 'package:flutter/material.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Shopper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111113)),
        useMaterial3: true,
      ),
      home: const CustomerHomeScreen(),
    );
  }
}

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Customer app foundation'),
        ),
      ),
    );
  }
}
```

**Step 4: Run tests**

Run:

```bash
cd apps/customer
flutter test
flutter build web
cd ../..
```

Expected: tests pass and web build succeeds.

**Step 5: Commit**

```bash
git add apps/customer
git commit -m "feat: scaffold customer flutter app"
```

---

### Task 5.2: Add Customer Runtime Workspace Config Provider

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/core/config/workspace_config.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/core/config/workspace_config_provider.dart`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/app.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/workspace_config_provider_test.dart`

**Step 1: Write provider test**

Create `apps/customer/test/workspace_config_provider_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer/core/config/workspace_config_provider.dart';

void main() {
  test('workspace config provider exposes fallback runtime config', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final config = container.read(workspaceConfigProvider);

    expect(config.publicName, 'Personal Shopper');
    expect(config.defaultLanguage, 'fr');
  });
}
```

**Step 2: Run test to verify failure**

Run:

```bash
cd apps/customer
flutter test test/workspace_config_provider_test.dart
cd ../..
```

Expected: fails because provider does not exist.

**Step 3: Add config model and provider**

Create `apps/customer/lib/core/config/workspace_config.dart`:

```dart
class WorkspaceConfig {
  const WorkspaceConfig({
    required this.publicName,
    required this.defaultLanguage,
    required this.primaryColorHex,
  });

  final String publicName;
  final String defaultLanguage;
  final String primaryColorHex;
}
```

Create `apps/customer/lib/core/config/workspace_config_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace_config.dart';

final workspaceConfigProvider = Provider<WorkspaceConfig>((ref) {
  return const WorkspaceConfig(
    publicName: 'Personal Shopper',
    defaultLanguage: 'fr',
    primaryColorHex: '#111113',
  );
});
```

**Step 4: Use runtime name in app shell**

Modify `apps/customer/lib/app.dart` so `CustomerApp` reads the provider through a small `ConsumerWidget`.

**Step 5: Run tests**

Run:

```bash
cd apps/customer
flutter test
cd ../..
```

Expected: tests pass.

**Step 6: Commit**

```bash
git add apps/customer/lib apps/customer/test
git commit -m "feat: add customer workspace config provider"
```

---

## Phase 6: Flutter Admin Web App

### Task 6.1: Generate Admin Flutter Web App

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/`

**Step 1: Generate Flutter app**

Run:

```bash
flutter create --platforms=web apps/admin
```

**Step 2: Add Riverpod**

Run:

```bash
cd apps/admin
flutter pub add flutter_riverpod go_router
cd ../..
```

**Step 3: Replace generated counter app with admin shell**

Modify `apps/admin/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  runApp(const ProviderScope(child: AdminApp()));
}
```

Create `apps/admin/lib/app.dart`:

```dart
import 'package:flutter/material.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Shopper Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111113)),
        useMaterial3: true,
      ),
      home: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Admin app foundation'),
        ),
      ),
    );
  }
}
```

**Step 4: Run tests**

Run:

```bash
cd apps/admin
flutter test
flutter build web
cd ../..
```

Expected: tests pass and web build succeeds.

**Step 5: Commit**

```bash
git add apps/admin
git commit -m "feat: scaffold admin flutter web app"
```

---

### Task 6.2: Add Admin Workspace Switcher Foundation

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/core/workspaces/workspace.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/core/workspaces/workspace_provider.dart`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/app.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/workspace_provider_test.dart`

**Step 1: Write provider test**

Create `apps/admin/test/workspace_provider_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin/core/workspaces/workspace_provider.dart';

void main() {
  test('admin has a selected workspace placeholder', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final workspace = container.read(selectedWorkspaceProvider);

    expect(workspace.slug, 'demo-workspace');
  });
}
```

**Step 2: Run test to verify failure**

Run:

```bash
cd apps/admin
flutter test test/workspace_provider_test.dart
cd ../..
```

Expected: fails because provider does not exist.

**Step 3: Add workspace model and provider**

Create `apps/admin/lib/core/workspaces/workspace.dart`:

```dart
class Workspace {
  const Workspace({
    required this.id,
    required this.slug,
    required this.publicName,
  });

  final String id;
  final String slug;
  final String publicName;
}
```

Create `apps/admin/lib/core/workspaces/workspace_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workspace.dart';

final selectedWorkspaceProvider = Provider<Workspace>((ref) {
  return const Workspace(
    id: 'demo-workspace-id',
    slug: 'demo-workspace',
    publicName: 'Demo Workspace',
  );
});
```

**Step 4: Run tests**

Run:

```bash
cd apps/admin
flutter test
cd ../..
```

Expected: tests pass.

**Step 5: Commit**

```bash
git add apps/admin/lib apps/admin/test
git commit -m "feat: add admin workspace foundation"
```

---

## Phase 7: Design Tokens And 1:1 UI Migration Preparation

### Task 7.1: Extract Initial Design Tokens

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/design-tokens/package.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/design-tokens/tokens.json`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/packages/design-tokens/README.md`

**Step 1: Create package metadata**

Create `packages/design-tokens/package.json`:

```json
{
  "name": "@personal-shopper/design-tokens",
  "private": true,
  "version": "0.1.0",
  "scripts": {
    "build": "node -e \"JSON.parse(require('fs').readFileSync('tokens.json', 'utf8')); console.log('tokens ok')\"",
    "lint": "pnpm build",
    "test": "pnpm build"
  }
}
```

**Step 2: Add initial tokens**

Create `packages/design-tokens/tokens.json`:

```json
{
  "colors": {
    "background": "#fbfbfd",
    "foreground": "#111113",
    "card": "#ffffff",
    "muted": "#f1f1f3",
    "mutedForeground": "#6e6e73",
    "accent": "#f7f4ef",
    "border": "rgba(17, 17, 19, 0.09)"
  },
  "radius": {
    "card": 18,
    "control": 16,
    "pill": 999
  },
  "motion": {
    "fastMs": 160,
    "normalMs": 240,
    "slowMs": 360
  }
}
```

**Step 3: Add README**

Create `packages/design-tokens/README.md`:

```markdown
# Design Tokens

Shared visual values extracted from the designer reference.

These are starter tokens. During Flutter UI migration, update them only when the value is reused across screens or apps.
```

**Step 4: Validate**

Run:

```bash
pnpm --filter @personal-shopper/design-tokens build
```

Expected: `tokens ok`.

**Step 5: Commit**

```bash
git add packages/design-tokens package.json pnpm-lock.yaml
git commit -m "feat: add initial design tokens"
```

---

### Task 7.2: Create UI Migration Checklist

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/ui-migration.md`

**Step 1: Add checklist**

Create `docs/ui-migration.md`:

```markdown
# UI Migration Checklist

Use the designer source under `docs/design-source/` as the reference for Flutter UI migration.

For each screen:

- Capture the React reference screen at mobile and desktop/tablet sizes when relevant.
- Rebuild the screen in Flutter.
- Match layout, spacing, typography, colors, cards, status indicators, and empty states.
- Match motion with Flutter native animations where practical.
- Add widget tests for important states.
- Add screenshot/golden tests only for screens where visual fidelity matters enough to justify maintenance.

Do not copy real shopper-specific names into reusable product source.
```

**Step 2: Commit**

```bash
git add docs/ui-migration.md
git commit -m "docs: add flutter ui migration checklist"
```

---

## Phase 8: Final Verification

### Task 8.1: Run Full Foundation Verification

**Files:**
- Modify: none

**Step 1: Run JavaScript/TypeScript checks**

Run:

```bash
pnpm install
pnpm -r build
pnpm -r lint
pnpm -r test
```

Expected: all configured package checks pass.

**Step 2: Run Flutter checks**

Run:

```bash
cd apps/customer
flutter test
flutter build web
cd ../admin
flutter test
flutter build web
cd ../..
```

Expected: customer/admin tests pass and web builds succeed.

**Step 3: Check git state**

Run:

```bash
git status --short
```

Expected: clean working tree.

**Step 4: Commit**

No commit unless final verification required small fixes. If fixes were required, commit them with:

```bash
git add <fixed-files>
git commit -m "chore: stabilize monorepo foundation"
```

---

## Phase 9: Next Implementation Plans

After this foundation lands, create separate plans for:

1. API request-to-quote-to-payment workflow.
2. Customer Flutter UI 1:1 migration.
3. Admin Flutter UI 1:1 migration.
4. Runtime workspace branding from admin to API to customer app.
5. Real Mobile Money provider integrations after provider credentials and API documentation are available.
