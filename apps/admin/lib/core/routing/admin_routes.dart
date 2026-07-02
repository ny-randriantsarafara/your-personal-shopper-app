import 'package:go_router/go_router.dart';

import '../../features/dashboard/admin_overview_screen.dart';
import '../../shared/layout/admin_shell.dart';

/// Builds the admin app router. All staff workspaces (overview, shopper,
/// logistics, settings, quote creation) live behind [AdminShell]. Route swaps
/// are instant; entrance motion is handled per-screen.
GoRouter createAdminRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AdminOverviewScreen()),
          ),
        ],
      ),
    ],
  );
}
