import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'status_badge.dart';

class _TrackingStep {
  const _TrackingStep({required this.percent, required this.label});

  final int percent;
  final String label;
}

_TrackingStep _stepFor(OrderStatus status) {
  return switch (status) {
    OrderStatus.submitted ||
    OrderStatus.quoteAvailable ||
    OrderStatus.quoteAccepted => const _TrackingStep(percent: 0, label: ''),
    OrderStatus.paid => const _TrackingStep(
      percent: 10,
      label: 'Payment confirmed. Shopper preparing to buy.',
    ),
    OrderStatus.purchased => const _TrackingStep(
      percent: 25,
      label: 'Item purchased. Awaiting delivery to overseas warehouse.',
    ),
    OrderStatus.warehouseReceived => const _TrackingStep(
      percent: 50,
      label: 'Received at overseas warehouse. Preparing for shipment.',
    ),
    OrderStatus.internationalTransit => const _TrackingStep(
      percent: 75,
      label: 'In transit to Madagascar. Expected soon.',
    ),
    OrderStatus.arrivedInMadagascar => const _TrackingStep(
      percent: 90,
      label: 'Arrived in Antananarivo. Ready for local dispatch.',
    ),
    OrderStatus.delivered => const _TrackingStep(
      percent: 100,
      label: 'Package delivered.',
    ),
  };
}

/// Shows a thin progress bar with a status caption for active shipments,
/// mirroring the designer `TrackingProgress`. Renders nothing before payment.
class TrackingProgress extends StatelessWidget {
  const TrackingProgress({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final step = _stepFor(status);
    if (step.percent == 0) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 448),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                step.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF71717A),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: step.percent / 100,
                minHeight: 6,
                backgroundColor: AppColors.muted,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
