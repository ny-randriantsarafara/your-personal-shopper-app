import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';

/// Customer orders dashboard, mirroring the designer `ClientDashboard`.
class OrdersDashboardScreen extends ConsumerWidget {
  const OrdersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DashboardHeader(
              onNewRequest: () => context.go('/requests/new'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.onNewRequest});

  final VoidCallback onNewRequest;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Your Orders',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                height: 1.1,
                color: AppColors.foreground,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Track your international purchases effortlessly.',
              style: TextStyle(fontSize: 17, color: AppColors.mutedForeground),
            ),
          ],
        ),
        AppButton(
          label: 'New Request',
          icon: Icons.add,
          onPressed: onNewRequest,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          radius: 18,
        ),
      ],
    );
  }
}
