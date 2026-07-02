import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';

/// Title and subtitle shown at the top of each account settings panel.
class SettingsPanelHeading extends StatelessWidget {
  const SettingsPanelHeading({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.mutedForeground,
          ),
        ),
      ],
    );
  }
}
