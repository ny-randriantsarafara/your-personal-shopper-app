import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/format/number_format.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/back_link.dart';
import '../orders/order_controller.dart';
import 'payment_method_tile.dart';

const List<String> _paymentMethods = ['MVola', 'Orange Money', 'Airtel Money'];

/// Mobile Money method selection and authorization, mirroring the designer
/// `PaymentSimulation`.
class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  int _selectedMethod = 0;

  void _authorize() {
    ref
        .read(orderControllerProvider.notifier)
        .markPaymentAuthorized(widget.requestId);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final request = ref
        .watch(orderControllerProvider.notifier)
        .requestById(widget.requestId);
    final total = request?.quote?.totalMGA ?? 0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 576),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackLink(label: 'Cancel Payment', onTap: () => context.go('/')),
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
                  const SizedBox(height: 8),
                  const Text(
                    'Complete Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _TotalAmount(total: total),
                  const SizedBox(height: 40),
                  for (var i = 0; i < _paymentMethods.length; i++) ...[
                    PaymentMethodTile(
                      label: _paymentMethods[i],
                      selected: _selectedMethod == i,
                      onTap: () => setState(() => _selectedMethod = i),
                    ),
                    if (i < _paymentMethods.length - 1)
                      const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 40),
                  AppButton(
                    label: 'Authorize Payment',
                    icon: Icons.smartphone,
                    onPressed: _authorize,
                    fullWidth: true,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    fontSize: 17,
                    radius: 20,
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

class _TotalAmount extends StatelessWidget {
  const _TotalAmount({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
          color: AppColors.foreground,
        ),
        children: [
          TextSpan(text: groupThousands(total)),
          const TextSpan(
            text: ' MGA',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFFA1A1AA),
            ),
          ),
        ],
      ),
    );
  }
}
