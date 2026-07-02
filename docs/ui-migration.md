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
