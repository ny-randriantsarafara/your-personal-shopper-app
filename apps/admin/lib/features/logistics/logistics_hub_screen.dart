import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/staff_request_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../requests/admin_request_controller.dart';
import '../requests/admin_request_models.dart';

const List<OrderStatus> _activeStatuses = [
  OrderStatus.purchased,
  OrderStatus.warehouseReceived,
  OrderStatus.internationalTransit,
  OrderStatus.arrivedInMadagascar,
];

/// Logistics workspace for advancing parcels through fulfilment stages,
/// mirroring the designer `LogisticsDashboard`.
class LogisticsHubScreen extends ConsumerWidget {
  const LogisticsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(adminRequestControllerProvider);
    final activeParcels = requests
        .where((request) => _activeStatuses.contains(request.status))
        .toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const SizedBox(height: 40),
            if (activeParcels.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No active logistics tasks.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.mutedForeground,
                  ),
                ),
              )
            else
              for (final request in activeParcels) ...[
                StaffRequestCard(
                  request: request,
                  subtitle: const _Destination(),
                  action: _LogisticsAction(request: request),
                ),
                const SizedBox(height: 20),
              ],
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Logistics Hub',
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
          'Manage receiving, shipping, and delivery.',
          style: TextStyle(fontSize: 18, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}

class _Destination extends StatelessWidget {
  const _Destination();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Destination: Antananarivo, Madagascar',
      style: TextStyle(fontSize: 15, color: AppColors.mutedForeground),
    );
  }
}

class _LogisticsAction extends ConsumerWidget {
  const _LogisticsAction({required this.request});

  final ProductRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(adminRequestControllerProvider.notifier);

    return switch (request.status) {
      OrderStatus.purchased => AppButton(
        label: 'Receive Box',
        icon: Icons.inventory_2_outlined,
        onPressed: () => controller.receiveWarehouse(request.id),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      ),
      OrderStatus.warehouseReceived => AppButton(
        label: 'Ship to Mada',
        icon: Icons.local_shipping_outlined,
        onPressed: () => controller.shipToMadagascar(request.id),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      ),
      OrderStatus.internationalTransit => AppButton(
        label: 'Arrived Mada',
        icon: Icons.place_outlined,
        onPressed: () => controller.markArrived(request.id),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      ),
      OrderStatus.arrivedInMadagascar => AppButton(
        label: 'Mark Delivered',
        variant: AppButtonVariant.green,
        icon: Icons.check,
        onPressed: () => controller.markDelivered(request.id),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      ),
      OrderStatus.submitted ||
      OrderStatus.quoteAvailable ||
      OrderStatus.quoteAccepted ||
      OrderStatus.paid ||
      OrderStatus.delivered => const SizedBox.shrink(),
    };
  }
}
