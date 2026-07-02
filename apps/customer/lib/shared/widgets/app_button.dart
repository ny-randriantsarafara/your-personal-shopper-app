import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// Visual variants for [AppButton], mapped from the designer button styles.
enum AppButtonVariant { primary, secondary, blue, green }

class _ButtonPalette {
  const _ButtonPalette({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_ButtonPalette _paletteFor(AppButtonVariant variant) {
  return switch (variant) {
    AppButtonVariant.primary => const _ButtonPalette(
      background: AppColors.foreground,
      foreground: Colors.white,
    ),
    AppButtonVariant.secondary => const _ButtonPalette(
      background: Color(0xFFF4F4F5),
      foreground: AppColors.foreground,
    ),
    AppButtonVariant.blue => const _ButtonPalette(
      background: Color(0xFF2563EB),
      foreground: Colors.white,
    ),
    AppButtonVariant.green => const _ButtonPalette(
      background: Color(0xFF16A34A),
      foreground: Colors.white,
    ),
  };
}

/// Rounded pill button used across designer screens. Supports an optional
/// leading or trailing icon and a full-width layout.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailingIcon,
    this.fullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.fontSize = 15,
    this.radius = AppRadii.control,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final palette = _paletteFor(variant);

    final content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: palette.foreground),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: palette.foreground,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 20, color: palette.foreground),
        ],
      ],
    );

    return Material(
      color: palette.background,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Padding(padding: padding, child: content),
      ),
    );
  }
}
