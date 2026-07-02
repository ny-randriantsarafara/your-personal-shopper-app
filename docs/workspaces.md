# Workspaces and runtime branding

Most configuration is editable from the admin app and stored in the API database. Visible brand content should not require recompiling an app.

## Runtime workspace settings

Stored in the API and applied at runtime:

- public brand name, logo, colors;
- support phone and WhatsApp, social links, office address, legal information;
- default language;
- enabled payment providers and Mobile Money receiver accounts;
- commissions, exchange rates, delivery fees;
- quote validity rules, service categories, feature flags.

## Customer app startup

```text
app starts
resolve workspace from build-time identity, domain, or deep link
fetch public workspace settings from API
apply branding, feature flags, and payment options at runtime
```

The customer app exposes a `WorkspaceConfig` provider (`apps/customer/lib/core/config/`) with a safe fallback so the shell renders before settings load.

## Build-time configuration

Limited to what app stores and platform builds require:

- bundle id, app name, app icon;
- associated domain;
- default API environment;
- default workspace slug/id for first resolution.

One source codebase can produce multiple customer app builds, but most visible brand content is runtime-driven.

## Admin

Admin remains one generic app. Admin users switch between the workspaces they belong to (`apps/admin/lib/core/workspaces/`), and only see actions their permissions allow.
