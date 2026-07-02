import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';

/// Radio-style selectable payment method row, mirroring the designer payment
/// operator options.
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? AppColors.card : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.foreground : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            _RadioDot(selected: selected),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.foreground : const Color(0xFFD4D4D8),
          width: selected ? 7 : 2,
        ),
      ),
    );
  }
}
