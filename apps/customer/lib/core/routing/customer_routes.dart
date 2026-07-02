import 'package:go_router/go_router.dart';

import '../../features/orders/orders_dashboard_screen.dart';
import '../../shared/layout/customer_shell.dart';

/// Builds the customer app router. Screens render inside [CustomerShell], which
/// provides the shared header chrome.
GoRouter createCustomerRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => CustomerShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const OrdersDashboardScreen(),
          ),
        ],
      ),
    ],
  );
}
