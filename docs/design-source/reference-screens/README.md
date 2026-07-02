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
