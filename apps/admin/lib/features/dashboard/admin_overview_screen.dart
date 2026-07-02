import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_colors.dart';

/// Platform overview for the admin workspace, mirroring the designer
/// `AdminDashboard`.
class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _OverviewHeader(),
          ],
        ),
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x0A111113))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Admin Overview',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.1,
              color: AppColors.foreground,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Platform metrics and global requests.',
            style: TextStyle(fontSize: 18, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}
