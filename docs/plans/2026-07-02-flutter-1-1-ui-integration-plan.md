# Flutter 1:1 UI Integration Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Rebuild the designer React prototype as best-effort 1:1 Flutter UI in the separate customer and admin apps, preserving visual hierarchy, spacing, interaction states, and motion while keeping admin code outside the customer app.

**Architecture:** Use `docs/design-source/personal-shopper-app-export/src/app/App.tsx` as the source of truth for screens, states, layout, and motion. Implement shared visual primitives separately in each app first, and only extract a shared Flutter package after duplication is proven painful. Keep customer-only screens in `apps/customer` and admin/shopper/logistics/account-management screens in `apps/admin`.

**Tech Stack:** Flutter, Riverpod, go_router, Material 3, built-in Flutter animations, widget tests, golden tests using Flutter's `matchesGoldenFile`, and existing design tokens in `packages/design-tokens/tokens.json`.

## Documentation and Artifact Disposition

- **Temporary artifacts:** `docs/plans/2026-07-02-flutter-1-1-ui-integration-plan.md`, screenshots captured under `docs/design-source/reference-screens/`.
- **Promote if validated:** update `docs/ui-migration.md` with the final 1:1 workflow, update `docs/architecture.md` with confirmed customer/admin UI boundaries, and add permanent screen inventory docs only if they remain useful after implementation.
- **Delete if not durable:** remove this plan after execution if `docs/ui-migration.md` and app tests become the durable record. Remove reference screenshots only if golden tests fully replace them.

---

## Source Inventory

Use this designer source:

```text
docs/design-source/personal-shopper-app-export/src/app/App.tsx
docs/design-source/personal-shopper-app-export/src/styles/theme.css
docs/design-source/personal-shopper-app-export/default_shadcn_theme.css
docs/design-source/personal-shopper-app-export/src/imports/pasted_text/mvp-personal-shopper-spec.md
```

Current implementation state:

```text
apps/customer/lib/app.dart
apps/customer/lib/core/config/workspace_config.dart
apps/customer/lib/core/config/workspace_config_provider.dart

apps/admin/lib/app.dart
apps/admin/lib/core/workspaces/workspace.dart
apps/admin/lib/core/workspaces/workspace_provider.dart
```

The current customer and admin apps are foundation shells. This plan replaces those shell screens with real Flutter screen structures.

Important rule: do not copy source-specific visible brand/person names into production UI. The React source contains names like `MadaShopper`, `Jean Rakoto`, and `MadaShopper Hub`; use neutral demo fixtures and runtime workspace config instead.

---

## Phase 1: Reference Capture And UI Contract

### Task 1.1: Create Reference Screen Inventory

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/README.md`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/ui-migration.md`

**Step 1: Write the screen inventory**

Create `docs/design-source/reference-screens/README.md`:

```markdown
# Reference Screens

Source: `docs/design-source/personal-shopper-app-export/src/app/App.tsx`

## Customer app screens

- Customer orders dashboard: `ClientDashboard`
- New request form: `NewRequestForm`
- Quote review: `QuoteReview`
- Payment method selection: `PaymentSimulation`

## Admin app screens

- Admin overview: `AdminDashboard`
- Shopper tasks: `ShopperDashboard`
- Quote creation: `QuoteCreateForm`
- Logistics hub: `LogisticsDashboard`
- Account settings: `AccountSettings`
- Workspace/profile switcher from root app header

## Shared source components to recreate

- `StatusBadge`
- `TrackingProgress`
- card surfaces
- pill buttons
- form fields
- header/workspace switcher shell
- page transition motion
- staggered card entry motion

## Brand safety

Do not copy source-specific brand/person names into generic app UI. Resolve visible brand from runtime workspace config in customer app and selected workspace in admin app.
```

**Step 2: Update the UI migration checklist**

Append to `docs/ui-migration.md`:

```markdown

## Current 1:1 source map

Use `docs/design-source/reference-screens/README.md` as the source-to-Flutter screen map.

Customer app receives customer-only screens. Admin app receives admin, shopper, logistics, quote creation, workspace switching, and settings screens.
```

**Step 3: Commit**

```bash
git add docs/design-source/reference-screens/README.md docs/ui-migration.md
git commit -m "docs: map designer screens to flutter apps"
```

---

### Task 1.2: Capture Browser Reference Screens

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/customer-orders-mobile.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/customer-orders-desktop.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/customer-new-request-mobile.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/customer-quote-review-mobile.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/customer-payment-mobile.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/admin-overview-desktop.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/admin-shopper-tasks-desktop.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/admin-logistics-desktop.png`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/docs/design-source/reference-screens/admin-account-settings-desktop.png`

**Step 1: Run the designer source locally**

Run:

```bash
cd docs/design-source/personal-shopper-app-export
pnpm install
pnpm dev --host 127.0.0.1
```

Expected: Vite serves the React prototype.

**Step 2: Capture screenshots**

Use the in-app browser or Playwright. Capture mobile at `390x844` and desktop at `1440x1000`.

Required interactions before capture:

- Customer orders: default `CLIENT` / `LIST`.
- New request: click `New Request`.
- Quote review: click `Review & Pay`.
- Payment: from quote review, click `Accept & Pay`.
- Admin overview: switch workspace to `Admin Console`.
- Shopper tasks: switch workspace to `Shopper`.
- Logistics: switch workspace to `Logistics Hub`.
- Account settings: open switcher, click `Account Settings`.

**Step 3: Commit screenshots**

```bash
git add docs/design-source/reference-screens
git commit -m "docs: capture designer reference screens"
```

---

## Phase 2: Shared Flutter Visual Language

### Task 2.1: Add App Design Tokens In Customer

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/theme/app_colors.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/theme/app_radii.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/theme/app_motion.dart`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/app.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/theme/app_theme_test.dart`

**Step 1: Write the failing test**

Create `apps/customer/test/theme/app_theme_test.dart`:

```dart
import 'package:customer/shared/theme/app_colors.dart';
import 'package:customer/shared/theme/app_motion.dart';
import 'package:customer/shared/theme/app_radii.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('customer app exposes designer visual tokens', () {
    expect(AppColors.background.value, 0xFFFBFBFD);
    expect(AppColors.foreground.value, 0xFF111113);
    expect(AppRadii.card, 28);
    expect(AppMotion.pageTransition.inMilliseconds, 400);
  });
}
```

**Step 2: Run test to verify failure**

Run:

```bash
cd apps/customer
flutter test test/theme/app_theme_test.dart
cd ../..
```

Expected: fails because token files do not exist.

**Step 3: Add token files**

Create `apps/customer/lib/shared/theme/app_colors.dart`:

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFFBFBFD);
  static const foreground = Color(0xFF111113);
  static const card = Color(0xFFFFFFFF);
  static const muted = Color(0xFFF1F1F3);
  static const input = Color(0xFFF6F6F7);
  static const accent = Color(0xFFF7F4EF);
  static const mutedForeground = Color(0xFF6E6E73);
  static const border = Color(0x17111113);
}
```

Create `apps/customer/lib/shared/theme/app_radii.dart`:

```dart
abstract final class AppRadii {
  static const double small = 14;
  static const double control = 16;
  static const double card = 28;
  static const double largeCard = 32;
}
```

Create `apps/customer/lib/shared/theme/app_motion.dart`:

```dart
abstract final class AppMotion {
  static const fast = Duration(milliseconds: 200);
  static const pageTransition = Duration(milliseconds: 400);
  static const exitTransition = Duration(milliseconds: 250);
  static const progress = Duration(milliseconds: 1000);
}
```

**Step 4: Apply theme**

Modify `apps/customer/lib/app.dart` so `MaterialApp.theme.scaffoldBackgroundColor` uses `AppColors.background`, text uses the black foreground, and Material 3 remains enabled.

**Step 5: Run tests**

```bash
cd apps/customer
flutter test
cd ../..
```

Expected: tests pass.

**Step 6: Commit**

```bash
git add apps/customer/lib/shared/theme apps/customer/lib/app.dart apps/customer/test/theme
git commit -m "feat(customer): add designer visual tokens"
```

---

### Task 2.2: Mirror Design Tokens In Admin

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/theme/app_colors.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/theme/app_radii.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/theme/app_motion.dart`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/app.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/theme/app_theme_test.dart`

**Step 1: Write the failing test**

Use the same token assertions as customer, with imports from `package:admin/...`.

**Step 2: Run failing test**

```bash
cd apps/admin
flutter test test/theme/app_theme_test.dart
cd ../..
```

Expected: fails.

**Step 3: Copy token files**

Copy the same token classes from customer into admin. Keep duplication for now; do not create `packages/flutter-ui` until at least two real screens prove the shape.

**Step 4: Apply theme**

Modify `apps/admin/lib/app.dart` to use the admin tokens.

**Step 5: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/shared/theme apps/admin/lib/app.dart apps/admin/test/theme
git commit -m "feat(admin): add designer visual tokens"
```

---

### Task 2.3: Add Shared Visual Widgets To Customer

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/widgets/app_card.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/widgets/app_button.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/widgets/app_text_field.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/widgets/status_badge.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/widgets/tracking_progress.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/shared/status_badge_test.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/shared/tracking_progress_test.dart`

**Step 1: Write status badge test**

Create `apps/customer/test/shared/status_badge_test.dart`:

```dart
import 'package:customer/shared/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders quote available status label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusBadge(status: OrderStatus.quoteAvailable)),
      ),
    );

    expect(find.text('Quote Ready'), findsOneWidget);
  });
}
```

**Step 2: Write tracking progress test**

Create `apps/customer/test/shared/tracking_progress_test.dart`:

```dart
import 'package:customer/shared/widgets/status_badge.dart';
import 'package:customer/shared/widgets/tracking_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hides progress for submitted status', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TrackingProgress(status: OrderStatus.submitted)),
      ),
    );

    expect(find.byType(LinearProgressIndicator), findsNothing);
  });

  testWidgets('shows purchased progress copy', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TrackingProgress(status: OrderStatus.purchased)),
      ),
    );

    expect(find.textContaining('Item purchased'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
```

**Step 3: Run tests to verify failure**

```bash
cd apps/customer
flutter test test/shared
cd ../..
```

Expected: fails because widgets do not exist.

**Step 4: Implement widgets**

Implement:

- `OrderStatus` enum inside `status_badge.dart` for now.
- `StatusBadge` label/color mapping from React `StatusBadge`.
- `TrackingProgress` copy and percentage mapping from React `TrackingProgress`.
- `AppCard` as a white rounded container with border and subtle shadow.
- `AppButton` with primary, secondary, blue, and green styles.
- `AppTextField` with `#F6F6F7`, 20px radius, 17px text.

Do not over-abstract. Keep constructors small and screen-driven.

**Step 5: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../..
git add apps/customer/lib/shared/widgets apps/customer/test/shared
git commit -m "feat(customer): add designer UI primitives"
```

---

### Task 2.4: Add Shared Visual Widgets To Admin

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/widgets/app_card.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/widgets/app_button.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/widgets/app_text_field.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/widgets/status_badge.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/widgets/tracking_progress.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/shared/status_badge_test.dart`

**Step 1: Write equivalent admin widget tests**

Use the same tests as customer with `package:admin/...` imports.

**Step 2: Implement equivalent widgets**

Copy the customer implementations for now. Do not create shared package yet.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/shared/widgets apps/admin/test/shared
git commit -m "feat(admin): add designer UI primitives"
```

---

## Phase 3: App State And Fixtures

### Task 3.1: Add Customer Demo Request State

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/orders/order_models.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/orders/order_fixtures.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/orders/order_controller.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/features/orders/order_controller_test.dart`

**Step 1: Write controller test**

Create `apps/customer/test/features/orders/order_controller_test.dart`:

```dart
import 'package:customer/features/orders/order_controller.dart';
import 'package:customer/shared/widgets/status_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('customer order controller can create a new submitted request', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(orderControllerProvider.notifier);
    controller.createRequest(title: 'Demo Product', url: 'https://example.com/product');

    final first = container.read(orderControllerProvider).first;
    expect(first.title, 'Demo Product');
    expect(first.status, OrderStatus.submitted);
  });
}
```

**Step 2: Run failing test**

```bash
cd apps/customer
flutter test test/features/orders/order_controller_test.dart
cd ../..
```

Expected: fails.

**Step 3: Implement model, fixtures, controller**

Model should include:

```dart
class ShopperQuote {
  const ShopperQuote({
    required this.productAmount,
    required this.exchangeRate,
    required this.serviceFee,
    required this.localDeliveryFee,
    required this.totalMGA,
  });

  final int productAmount;
  final int exchangeRate;
  final int serviceFee;
  final int localDeliveryFee;
  final int totalMGA;
}

class ProductRequest {
  const ProductRequest({
    required this.id,
    required this.title,
    required this.url,
    required this.status,
    this.imageUrl,
    this.quote,
  });

  final String id;
  final String title;
  final String url;
  final OrderStatus status;
  final String? imageUrl;
  final ShopperQuote? quote;
}
```

Use neutral fixtures:

- no real shopper names;
- no source-specific brand names;
- product examples are acceptable.

Controller actions:

- `createRequest`
- `selectRequest`
- `acceptQuote`
- `markPaymentAuthorized`

**Step 4: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../..
git add apps/customer/lib/features/orders apps/customer/test/features/orders
git commit -m "feat(customer): add order state for designer flow"
```

---

### Task 3.2: Add Admin Demo Workspace State

**Files:**
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/core/workspaces/workspace.dart`
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/core/workspaces/workspace_provider.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/requests/admin_request_models.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/requests/admin_request_fixtures.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/requests/admin_request_controller.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/requests/admin_request_controller_test.dart`

**Step 1: Write controller test**

Create `apps/admin/test/features/requests/admin_request_controller_test.dart`:

```dart
import 'package:admin/features/requests/admin_request_controller.dart';
import 'package:admin/shared/widgets/status_badge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('admin request controller can create a quote and update status', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(adminRequestControllerProvider.notifier);
    final submitted = container
        .read(adminRequestControllerProvider)
        .firstWhere((request) => request.status == OrderStatus.submitted);

    controller.createQuote(
      requestId: submitted.id,
      productAmount: 100,
      exchangeRate: 4600,
      serviceFee: 50000,
      localDeliveryFee: 15000,
    );

    final updated = container
        .read(adminRequestControllerProvider)
        .firstWhere((request) => request.id == submitted.id);

    expect(updated.status, OrderStatus.quoteAvailable);
    expect(updated.quote?.totalMGA, 525000);
  });
}
```

**Step 2: Run failing test**

```bash
cd apps/admin
flutter test test/features/requests/admin_request_controller_test.dart
cd ../..
```

Expected: fails.

**Step 3: Implement admin models and controller**

Implement the same request/quote concepts as customer, plus actions:

- `createQuote`
- `markPurchased`
- `receiveWarehouse`
- `shipToMadagascar`
- `markArrived`
- `markDelivered`

Use neutral fixture names and a `Demo Workspace` selected workspace.

**Step 4: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/core/workspaces apps/admin/lib/features/requests apps/admin/test/features/requests
git commit -m "feat(admin): add request state for designer flow"
```

---

## Phase 4: Customer App 1:1 Screens

### Task 4.1: Add Customer Routing And Shell

**Files:**
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/app.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/core/routing/customer_routes.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/layout/customer_shell.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/app_navigation_test.dart`

**Step 1: Write navigation test**

Create `apps/customer/test/app_navigation_test.dart`:

```dart
import 'package:customer/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('customer app starts on orders dashboard', (tester) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    expect(find.text('Your Orders'), findsOneWidget);
    expect(find.text('New Request'), findsOneWidget);
  });
}
```

**Step 2: Run failing test**

```bash
cd apps/customer
flutter test test/app_navigation_test.dart
cd ../..
```

Expected: fails because shell still says `Customer app foundation`.

**Step 3: Implement shell**

`CustomerShell` should match the source header shape without admin workspace switcher:

- background `#FBFBFD`;
- sticky-feeling top header for web, normal top area for mobile;
- left brand resolved from `workspaceConfigProvider.publicName`;
- black rounded 12px package icon equivalent;
- right profile chip only if needed later.

Use `go_router` for routes:

```text
/
/requests/new
/quotes/:requestId
/payments/:requestId
```

**Step 4: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../..
git add apps/customer/lib/app.dart apps/customer/lib/core/routing apps/customer/lib/shared/layout apps/customer/test/app_navigation_test.dart
git commit -m "feat(customer): add designer app shell and routing"
```

---

### Task 4.2: Implement Customer Orders Dashboard

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/orders/orders_dashboard_screen.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/orders/order_card.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/features/orders/orders_dashboard_screen_test.dart`

**Step 1: Write screen test**

Create `apps/customer/test/features/orders/orders_dashboard_screen_test.dart`:

```dart
import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('orders dashboard separates quote actions from active orders', (tester) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    expect(find.text('Your Orders'), findsOneWidget);
    expect(find.text('Needs Your Attention'), findsOneWidget);
    expect(find.text('Active & Past Orders'), findsOneWidget);
    expect(find.text('Review & Pay'), findsOneWidget);
  });
}
```

**Step 2: Run failing test**

Expected: fails until dashboard is implemented.

**Step 3: Implement dashboard**

Mirror `ClientDashboard`:

- max width around 4xl equivalent (`min(availableWidth, 896)`).
- heading `Your Orders`, subtitle `Track your international purchases effortlessly.`
- `New Request` black primary button.
- `Needs Your Attention` section for `quoteAvailable`.
- card image square with 18px radius.
- request id, status badge, title, URL row.
- quote total and blue `Review & Pay` action.
- `Active & Past Orders` section.
- submitted state pill: clock icon + `Awaiting Quote`.
- tracking progress for purchased and later statuses.

Motion:

- page enters with opacity + translateY + slight scale using `AnimatedSwitcher` or a custom `PageFadeSlide`.
- cards stagger by index with small delayed opacity/translate animations.
- buttons scale to `0.98` on press where practical.

**Step 4: Run tests and commit**

```bash
cd apps/customer
flutter test
flutter build web
cd ../..
git add apps/customer/lib/features/orders apps/customer/test/features/orders
git commit -m "feat(customer): implement designer orders dashboard"
```

---

### Task 4.3: Implement New Request Screen

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/requests/new_request_screen.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/features/requests/new_request_screen_test.dart`

**Step 1: Write test**

```dart
import 'package:customer/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('new request screen submits a request and returns to orders', (tester) async {
    await tester.pumpWidget(const CustomerApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('New Request'));
    await tester.pumpAndSettle();

    expect(find.text('What would you like to buy?'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Product Name'), 'Demo Product');
    await tester.enterText(find.bySemanticsLabel('Product Link (URL)'), 'https://example.com/demo');
    await tester.tap(find.text('Submit Request'));
    await tester.pumpAndSettle();

    expect(find.text('Demo Product'), findsOneWidget);
  });
}
```

**Step 2: Implement screen**

Mirror `NewRequestForm`:

- back button with left arrow and `Back to Requests`.
- centered max width around 672.
- white card, radius 32, padding 32 mobile / 48 larger.
- title `What would you like to buy?`.
- fields: Product Name, Product Link (URL), Max Budget.
- full-width black submit button.

**Step 3: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../..
git add apps/customer/lib/features/requests apps/customer/test/features/requests
git commit -m "feat(customer): implement designer new request flow"
```

---

### Task 4.4: Implement Quote Review Screen

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/quotes/quote_review_screen.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/features/quotes/quote_review_screen_test.dart`

**Step 1: Write test**

Test that tapping `Review & Pay` opens `Quote Details`, displays `Total to Pay`, and has `Accept & Pay` plus `Decline`.

**Step 2: Implement screen**

Mirror `QuoteReview`:

- back button.
- white radius 32 card.
- quote title/subtitle.
- quote breakdown in `#FBFBFD` radius 24 card:
  - Product Cost.
  - Exchange Rate.
  - Converted Cost.
  - Service Fee.
  - Local Delivery.
  - Total to Pay.
- primary `Accept & Pay`.
- secondary `Decline`.

**Step 3: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../..
git add apps/customer/lib/features/quotes apps/customer/test/features/quotes
git commit -m "feat(customer): implement designer quote review"
```

---

### Task 4.5: Implement Payment Selection Screen

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/payments/payment_screen.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/features/payments/payment_method_tile.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/features/payments/payment_screen_test.dart`

**Step 1: Write test**

Test that payment screen shows `Complete Payment`, total MGA, `MVola`, `Orange Money`, `Airtel Money`, and `Authorize Payment`.

**Step 2: Implement screen**

Mirror `PaymentSimulation`:

- max width around 576.
- back button `Cancel Payment`.
- white card radius 32.
- centered total amount.
- radio-style method cards:
  - selected card has black border.
  - unselected cards use light gray background and transparent border.
- black `Authorize Payment` button with phone icon.

Use current payment fixture state only. Do not call API in this UI pass.

**Step 3: Run tests and commit**

```bash
cd apps/customer
flutter test
flutter build web
cd ../..
git add apps/customer/lib/features/payments apps/customer/test/features/payments
git commit -m "feat(customer): implement designer payment selection"
```

---

## Phase 5: Admin App 1:1 Screens

### Task 5.1: Add Admin Routing, Shell, And Workspace Switcher

**Files:**
- Modify: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/app.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/core/routing/admin_routes.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/layout/admin_shell.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/layout/workspace_switcher.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/app_navigation_test.dart`

**Step 1: Write test**

Create a test that starts `AdminApp`, finds `Admin Overview`, opens the workspace switcher, and sees `Shopper`, `Logistics Hub`, `Admin Console`, and `Account Settings`.

**Step 2: Implement shell**

Mirror the root app header:

- background `#FBFBFD`.
- sticky top web header look.
- 80px high header.
- max width 1000.
- left generic admin brand from selected workspace/app config; do not use source brand names.
- right profile/workspace chip.
- dropdown width 320, white 95% opacity, blur where feasible, radius 24.
- user summary, switch workspace list, account settings, sign out.

Admin routes:

```text
/
/shopper
/logistics
/settings
/quotes/:requestId/create
```

Keep all admin/shopper/logistics routes inside admin app only.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/app.dart apps/admin/lib/core/routing apps/admin/lib/shared/layout apps/admin/test/app_navigation_test.dart
git commit -m "feat(admin): add designer shell and workspace switcher"
```

---

### Task 5.2: Implement Admin Overview

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/dashboard/admin_overview_screen.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/dashboard/admin_metric_card.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/dashboard/admin_overview_screen_test.dart`

**Step 1: Write test**

Assert the screen shows:

- `Admin Overview`
- `Platform metrics and global requests.`
- `Total Requests`
- `Delivered`
- `Active Users`
- `All Platform Requests`

**Step 2: Implement screen**

Mirror `AdminDashboard`:

- max width around 896.
- heading and border-bottom section.
- three metric cards with icons.
- all requests list with status badge and quote total/no quote text.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
flutter build web
cd ../..
git add apps/admin/lib/features/dashboard apps/admin/test/features/dashboard
git commit -m "feat(admin): implement designer admin overview"
```

---

### Task 5.3: Implement Shopper Tasks

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/shopper/shopper_tasks_screen.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/shopper/shopper_tasks_screen_test.dart`

**Step 1: Write test**

Assert shopper route shows `Shopper Tasks`, `Manage pending requests and active orders.`, and `Create Quote` for submitted requests.

**Step 2: Implement screen**

Mirror `ShopperDashboard`:

- max width around 768.
- request cards radius 24.
- request id/status/title/url.
- action button:
  - `Create Quote` for submitted.
  - `Mark Purchased` for paid.

`Create Quote` routes to `/quotes/:requestId/create`.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/features/shopper apps/admin/test/features/shopper
git commit -m "feat(admin): implement designer shopper tasks"
```

---

### Task 5.4: Implement Quote Creation

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/quotes/quote_create_screen.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/quotes/quote_create_screen_test.dart`

**Step 1: Write test**

Assert quote form shows:

- `Calculate Quote`
- `Request Details`
- `Product Amount`
- `Exchange Rate`
- `Service Fee`
- `Local Delivery`
- `Generate & Send Quote`

Submit values and assert the request returns to shopper/admin list as `Quote Ready`.

**Step 2: Implement screen**

Mirror `QuoteCreateForm`:

- back button.
- white radius 32 form card.
- request details inset card.
- 2-column grid on desktop/tablet, 1-column mobile fallback.
- default values `0`, `4600`, `50000`, `15000`.
- black full-width submit button.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/features/quotes apps/admin/test/features/quotes
git commit -m "feat(admin): implement designer quote creation"
```

---

### Task 5.5: Implement Logistics Hub

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/logistics/logistics_hub_screen.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/logistics/logistics_hub_screen_test.dart`

**Step 1: Write test**

Assert logistics route shows `Logistics Hub`, active parcel cards, and the appropriate action button for at least one active status.

**Step 2: Implement screen**

Mirror `LogisticsDashboard`:

- max width around 768.
- active statuses:
  - purchased.
  - warehouse received.
  - international transit.
  - arrived in Madagascar.
- buttons:
  - `Receive Box`.
  - `Ship to Mada`.
  - `Arrived Mada`.
  - `Mark Delivered`.
- empty state: `No active logistics tasks.`

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
cd ../..
git add apps/admin/lib/features/logistics apps/admin/test/features/logistics
git commit -m "feat(admin): implement designer logistics hub"
```

---

### Task 5.6: Implement Account Settings

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/account_settings_screen.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/settings_nav.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/profile_settings_panel.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/security_settings_panel.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/mobile_money_settings_panel.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/features/settings/address_settings_panel.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/features/settings/account_settings_screen_test.dart`

**Step 1: Write test**

Assert settings route shows:

- `Settings that stay out of your way.`
- nav items `Profile`, `Security`, `Mobile Money`, `Addresses`.
- default profile panel.
- tapping `Mobile Money` shows `MVola`, `Orange Money`, and `Airtel Money`.

**Step 2: Implement settings screen**

Mirror `AccountSettings`:

- back button `Back to Dashboard`.
- heading and subtitle.
- profile summary pill on desktop.
- 280px left nav on desktop, top/stacked nav on mobile.
- white nav panel radius 26.
- content panel radius 30.
- animated panel transitions with `AnimatedSwitcher`.

Panel content:

- Profile form.
- Security password form and two-step notice.
- Mobile Money account list.
- Address cards and delivery preference note.

Use neutral demo user and workspace data.

**Step 3: Run tests and commit**

```bash
cd apps/admin
flutter test
flutter build web
cd ../..
git add apps/admin/lib/features/settings apps/admin/test/features/settings
git commit -m "feat(admin): implement designer account settings"
```

---

## Phase 6: Motion And Visual Fidelity Pass

### Task 6.1: Add Page And Card Motion Helpers

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/motion/page_transition.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/lib/shared/motion/staggered_entry.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/motion/page_transition.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/lib/shared/motion/staggered_entry.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/shared/motion/page_transition_test.dart`
- Test: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/shared/motion/page_transition_test.dart`

**Step 1: Write smoke tests**

Each app should pump a `PageFadeSlideTransition` and verify child content appears after `pumpAndSettle`.

**Step 2: Implement helpers**

Match source motion:

```text
page initial: opacity 0, y 12, scale .99
page animate: opacity 1, y 0, scale 1, duration 400ms
page exit equivalent: duration 250ms where route switch supports it
stagger cards: opacity 0, y 15, 80ms stagger
dropdown: opacity 0, y 8, scale .96, duration 200ms
progress: width from 0 to pct over 1000ms
button press: scale .98 where practical
```

**Step 3: Apply helpers**

Apply to all implemented customer and admin screens.

**Step 4: Run tests and commit**

```bash
cd apps/customer
flutter test
cd ../admin
flutter test
cd ../..
git add apps/customer/lib/shared/motion apps/admin/lib/shared/motion apps/customer/lib apps/admin/lib apps/customer/test/shared/motion apps/admin/test/shared/motion
git commit -m "feat: match designer motion patterns"
```

---

### Task 6.2: Add High-Value Golden Tests

**Files:**
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/goldens/customer_orders_dashboard_golden_test.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/customer/test/goldens/customer_payment_golden_test.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/goldens/admin_overview_golden_test.dart`
- Create: `/Users/nrandriantsarafara/Works/your-personal-shopper-app/apps/admin/test/goldens/admin_settings_golden_test.dart`

**Step 1: Write golden tests**

Use Flutter's built-in `matchesGoldenFile`. Test fixed sizes:

```text
customer mobile: 390x844
customer web/tablet: 900x900
admin desktop: 1440x1000
admin tablet: 1024x900
```

**Step 2: Generate goldens**

Run:

```bash
cd apps/customer
flutter test --update-goldens test/goldens
cd ../admin
flutter test --update-goldens test/goldens
cd ../..
```

**Step 3: Review goldens against reference screenshots**

Open the generated images and compare manually against `docs/design-source/reference-screens/`.

Fix only meaningful mismatches:

- hierarchy;
- spacing;
- broken responsive layout;
- wrong status/action states;
- missing major motion target final states.

Do not chase pixel-perfect browser-vs-Flutter rendering differences that do not affect product quality.

**Step 4: Commit**

```bash
git add apps/customer/test/goldens apps/admin/test/goldens
git commit -m "test: add golden coverage for designer screens"
```

---

## Phase 7: Full Verification

### Task 7.1: Run Customer Verification

**Files:**
- Modify only if verification finds issues.

**Step 1: Analyze**

```bash
cd apps/customer
flutter analyze
```

Expected: no issues.

**Step 2: Test**

```bash
flutter test
```

Expected: all tests pass.

**Step 3: Build web**

```bash
flutter build web
cd ../..
```

Expected: web build succeeds.

**Step 4: Commit fixes if needed**

```bash
git add apps/customer
git commit -m "chore(customer): stabilize designer ui integration"
```

Only commit if fixes were required.

---

### Task 7.2: Run Admin Verification

**Files:**
- Modify only if verification finds issues.

**Step 1: Analyze**

```bash
cd apps/admin
flutter analyze
```

Expected: no issues.

**Step 2: Test**

```bash
flutter test
```

Expected: all tests pass.

**Step 3: Build web**

```bash
flutter build web
cd ../..
```

Expected: web build succeeds.

**Step 4: Commit fixes if needed**

```bash
git add apps/admin
git commit -m "chore(admin): stabilize designer ui integration"
```

Only commit if fixes were required.

---

### Task 7.3: Run Monorepo Verification

**Files:**
- Modify only if verification finds issues.

**Step 1: Run JS/TS checks**

```bash
pnpm -r build
pnpm -r lint
pnpm -r test
```

Expected: all configured package checks pass.

**Step 2: Check workspace cleanliness**

```bash
git status --short
```

Expected: clean working tree, unless generated goldens were intentionally updated and already committed.

**Step 3: Final comparison**

Open customer and admin Flutter web builds next to the reference screenshots. Record any accepted non-1:1 differences in `docs/ui-migration.md`.

**Step 4: Commit documented exceptions if needed**

```bash
git add docs/ui-migration.md
git commit -m "docs: record accepted ui migration differences"
```

Only commit if exceptions were documented.

---

## Implementation Notes

- Customer app must not import admin files or include admin/shopper/logistics screens.
- Admin app may include shopper/logistics/admin workspace screens because those are staff/admin workflows.
- Keep Mobile Money UI provider names visible where appropriate: MVola, Orange Money, Airtel Money.
- Keep runtime brand configurable. Do not hardcode source brand names into screen headings.
- Prefer Flutter-native widgets and animations over WebView or embedded React.
- Defer API wiring. This plan focuses on 1:1 UI and local state parity with the designer source.
- After this plan lands, create a separate API integration plan to replace fixtures with real endpoints.
