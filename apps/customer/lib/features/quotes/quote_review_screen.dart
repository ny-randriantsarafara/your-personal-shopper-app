import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/format/number_format.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/back_link.dart';
import '../orders/order_controller.dart';
import '../orders/order_models.dart';

/// Quote breakdown and accept/decline actions, mirroring the designer
/// `QuoteReview`.
class QuoteReviewScreen extends ConsumerWidget {
  const QuoteReviewScreen({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref
        .watch(orderControllerProvider.notifier)
        .requestById(requestId);
    final quote = request?.quote;

    if (request == null || quote == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 672),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackLink(label: 'Back to Requests', onTap: () => context.go('/')),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 32,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Quote Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    request.title,
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _Breakdown(quote: quote),
                  const SizedBox(height: 32),
                  _Actions(
                    onAccept: () {
                      ref
                          .read(orderControllerProvider.notifier)
                          .acceptQuote(requestId);
                      context.go('/payments/$requestId');
                    },
                    onDecline: () => context.go('/'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.quote});

  final ShopperQuote quote;

  @override
  Widget build(BuildContext context) {
    final converted = quote.productAmount * quote.exchangeRate;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x08000000)),
      ),
      child: Column(
        children: [
          _Row(label: 'Product Cost', value: '€ ${groupThousands(quote.productAmount)}'),
          const SizedBox(height: 16),
          _Row(
            label: 'Exchange Rate',
            value: '1 € = ${quote.exchangeRate} MGA',
          ),
          const _Divider(),
          _Row(
            label: 'Converted Cost',
            value: '${groupThousands(converted)} MGA',
          ),
          const SizedBox(height: 16),
          _Row(
            label: 'Service Fee',
            value: '${groupThousands(quote.serviceFee)} MGA',
          ),
          const SizedBox(height: 16),
          _Row(
            label: 'Local Delivery',
            value: '${groupThousands(quote.localDeliveryFee)} MGA',
          ),
          const _Divider(),
          _Row(
            label: 'Total to Pay',
            value: '${groupThousands(quote.totalMGA)} MGA',
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: emphasized ? 18 : 15,
            fontWeight: emphasized ? FontWeight.w600 : FontWeight.w400,
            color: emphasized ? AppColors.foreground : AppColors.mutedForeground,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: emphasized ? 24 : 15,
            fontWeight: emphasized ? FontWeight.w600 : FontWeight.w500,
            letterSpacing: emphasized ? -0.5 : 0,
            color: AppColors.foreground,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(height: 1, thickness: 1, color: Color(0x14111113)),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({required this.onAccept, required this.onDecline});

  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Accept & Pay',
            trailingIcon: Icons.arrow_forward,
            onPressed: onAccept,
            fullWidth: true,
            padding: const EdgeInsets.symmetric(vertical: 16),
            fontSize: 17,
            radius: 20,
          ),
        ),
        const SizedBox(width: 16),
        AppButton(
          label: 'Decline',
          variant: AppButtonVariant.secondary,
          onPressed: onDecline,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 17,
          radius: 20,
        ),
      ],
    );
  }
}
