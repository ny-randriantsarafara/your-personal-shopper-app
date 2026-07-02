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

## Current 1:1 source map

Use `docs/design-source/reference-screens/README.md` as the source-to-Flutter screen map.

Customer app receives customer-only screens. Admin app receives admin, shopper, logistics, quote creation, workspace switching, and settings screens.

## Accepted non-1:1 differences

The following intentional deviations from the React designer source were accepted during the Flutter integration. They do not affect product hierarchy, spacing, states, or motion targets.

- **Reference screenshots skipped.** Browser reference captures were not stored. The committed Flutter golden tests under `apps/customer/test/goldens/` and `apps/admin/test/goldens/` are the visual record and regression baseline instead.
- **Golden text rendering.** Goldens are generated in `flutter test`, which uses the placeholder test font (text renders as filled boxes). This is expected and only affects glyph shapes, not layout, spacing, color, or component structure.
- **Motion at the widget layer.** Route swaps use `NoTransitionPage`; page-entry and card-stagger motion is implemented via `PageFadeSlideTransition` and `StaggeredEntry` on the screens themselves, matching the source's opacity/translate/scale timings.
- **Neutral demo data.** Names, phone numbers, and addresses use neutral placeholders rather than the source's shopper-specific identities. Mobile Money provider names (MVola, Orange Money, Airtel Money) are preserved.
- **Runtime brand.** Header brand text is driven by the workspace/runtime config and is not hardcoded to the source brand.
- **API deferred.** Screens are backed by local Riverpod fixtures; real endpoint wiring is out of scope for this UI pass.
