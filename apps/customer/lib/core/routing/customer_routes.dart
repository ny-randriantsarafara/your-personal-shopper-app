import 'package:go_router/go_router.dart';

import '../../features/orders/orders_dashboard_screen.dart';
import '../../features/requests/new_request_screen.dart';
import '../../shared/layout/customer_shell.dart';

/// Builds the customer app router. Screens render inside [CustomerShell], which
/// provides the shared header chrome. Route swaps are instant; entrance motion
/// is handled per-screen so it can mirror the designer content animations.
GoRouter createCustomerRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => CustomerShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: OrdersDashboardScreen()),
          ),
          GoRoute(
            path: '/requests/new',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NewRequestScreen()),
          ),
        ],
      ),
    ],
  );
}
