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
