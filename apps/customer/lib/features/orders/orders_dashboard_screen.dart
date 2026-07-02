import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/format/number_format.dart';
import '../../shared/motion/staggered_entry.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/status_badge.dart';
import 'order_card.dart';
import 'order_controller.dart';
import 'order_models.dart';

/// Customer orders dashboard, mirroring the designer `ClientDashboard`. Splits
/// requests that need action (available quotes) from active and past orders.
class OrdersDashboardScreen extends ConsumerWidget {
  const OrdersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(orderControllerProvider);
    final actionRequired = requests
        .where((request) => request.status == OrderStatus.quoteAvailable)
        .toList();
    final otherRequests = requests
        .where((request) => request.status != OrderStatus.quoteAvailable)
        .toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DashboardHeader(onNewRequest: () => context.go('/requests/new')),
            const SizedBox(height: 48),
            if (actionRequired.isNotEmpty) ...[
              const _SectionLabel('Needs Your Attention'),
              const SizedBox(height: 16),
              for (final (index, request) in actionRequired.indexed) ...[
                StaggeredEntry(
                  index: index,
                  child: OrderCard(
                    request: request,
                    highlighted: true,
                    trailing: _AttentionTrailing(
                      request: request,
                      onReviewAndPay: () =>
                          context.go('/quotes/${request.id}'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 16),
            ],
            if (actionRequired.isNotEmpty) ...[
              const _SectionLabel('Active & Past Orders'),
              const SizedBox(height: 16),
            ],
            for (final (index, request) in otherRequests.indexed) ...[
              StaggeredEntry(
                index: actionRequired.length + index,
                child: OrderCard(
                  request: request,
                  showTracking: true,
                  trailing: _StandardTrailing(request: request),
                ),
              ),
              const SizedBox(height: 16),
            ],
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
          radius: 18,
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Color(0xFF18181B),
        ),
      ),
    );
  }
}

class _AttentionTrailing extends StatelessWidget {
  const _AttentionTrailing({
    required this.request,
    required this.onReviewAndPay,
  });

  final ProductRequest request;
  final VoidCallback onReviewAndPay;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Quote Total',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: 2),
        _MgaAmount(amount: request.quote?.totalMGA ?? 0, size: 24),
        const SizedBox(height: 12),
        AppButton(
          label: 'Review & Pay',
          variant: AppButtonVariant.blue,
          onPressed: onReviewAndPay,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          radius: 14,
        ),
      ],
    );
  }
}

class _StandardTrailing extends StatelessWidget {
  const _StandardTrailing({required this.request});

  final ProductRequest request;

  @override
  Widget build(BuildContext context) {
    if (request.status == OrderStatus.submitted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule, size: 16, color: Color(0xFFA1A1AA)),
            SizedBox(width: 8),
            Text(
              'Awaiting Quote',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFA1A1AA),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Total Paid',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.mutedForeground,
          ),
        ),
        const SizedBox(height: 2),
        _MgaAmount(amount: request.quote?.totalMGA ?? 0, size: 20),
      ],
    );
  }
}

class _MgaAmount extends StatelessWidget {
  const _MgaAmount({required this.amount, required this.size});

  final int amount;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: AppColors.foreground,
        ),
        children: [
          TextSpan(text: groupThousands(amount)),
          const TextSpan(
            text: ' MGA',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA1A1AA),
            ),
          ),
        ],
      ),
    );
  }
}
