import 'package:flutter/material.dart';

/// Lifecycle of a product purchase request, mirroring the designer `Status`
/// union in `App.tsx`.
enum OrderStatus {
  submitted,
  quoteAvailable,
  quoteAccepted,
  paid,
  purchased,
  warehouseReceived,
  internationalTransit,
  arrivedInMadagascar,
  delivered,
}

class _BadgeStyle {
  const _BadgeStyle({
    required this.background,
    required this.foreground,
    required this.label,
  });

  final Color background;
  final Color foreground;
  final String label;
}

_BadgeStyle _styleFor(OrderStatus status) {
  return switch (status) {
    OrderStatus.submitted => const _BadgeStyle(
      background: Color(0xFFF4F4F5),
      foreground: Color(0xFF52525B),
      label: 'Pending Quote',
    ),
    OrderStatus.quoteAvailable => const _BadgeStyle(
      background: Color(0xFFEFF6FF),
      foreground: Color(0xFF1D4ED8),
      label: 'Quote Ready',
    ),
    OrderStatus.quoteAccepted => const _BadgeStyle(
      background: Color(0xFFF4F4F5),
      foreground: Color(0xFF27272A),
      label: 'Awaiting Payment',
    ),
    OrderStatus.paid => const _BadgeStyle(
      background: Color(0xFFF0FDF4),
      foreground: Color(0xFF15803D),
      label: 'Paid',
    ),
    OrderStatus.purchased => const _BadgeStyle(
      background: Color(0xFFFFF7ED),
      foreground: Color(0xFFC2410C),
      label: 'Purchased',
    ),
    OrderStatus.warehouseReceived => const _BadgeStyle(
      background: Color(0xFFFAF5FF),
      foreground: Color(0xFF7E22CE),
      label: 'At Warehouse',
    ),
    OrderStatus.internationalTransit => const _BadgeStyle(
      background: Color(0xFFEEF2FF),
      foreground: Color(0xFF4338CA),
      label: 'In Transit',
    ),
    OrderStatus.arrivedInMadagascar => const _BadgeStyle(
      background: Color(0xFFF0FDFA),
      foreground: Color(0xFF0F766E),
      label: 'Arrived Tana',
    ),
    OrderStatus.delivered => const _BadgeStyle(
      background: Color(0xFF000000),
      foreground: Color(0xFFFFFFFF),
      label: 'Delivered',
    ),
  };
}

/// Pill badge that maps an [OrderStatus] to a colored label, matching the
/// designer `StatusBadge`.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: style.foreground,
        ),
      ),
    );
  }
}
