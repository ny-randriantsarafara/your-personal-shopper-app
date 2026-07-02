import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// White rounded surface with a hairline border and a soft shadow, matching the
/// designer card surfaces.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = AppRadii.card,
    this.borderColor = AppColors.border,
    this.backgroundColor = AppColors.card,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
