import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/back_link.dart';
import '../requests/admin_request_controller.dart';
import '../requests/admin_request_models.dart';

/// Shopper quote calculator, mirroring the designer `QuoteCreateForm`.
class QuoteCreateScreen extends ConsumerStatefulWidget {
  const QuoteCreateScreen({required this.requestId, super.key});

  final String requestId;

  @override
  ConsumerState<QuoteCreateScreen> createState() => _QuoteCreateScreenState();
}

class _QuoteCreateScreenState extends ConsumerState<QuoteCreateScreen> {
  final _productAmount = TextEditingController(text: '0');
  final _exchangeRate = TextEditingController(text: '4600');
  final _serviceFee = TextEditingController(text: '50000');
  final _localDelivery = TextEditingController(text: '15000');

  static const double _gridBreakpoint = 640;

  @override
  void dispose() {
    _productAmount.dispose();
    _exchangeRate.dispose();
    _serviceFee.dispose();
    _localDelivery.dispose();
    super.dispose();
  }

  int _parse(TextEditingController controller) {
    return int.tryParse(controller.text.trim()) ?? 0;
  }

  void _submit() {
    ref
        .read(adminRequestControllerProvider.notifier)
        .createQuote(
          requestId: widget.requestId,
          productAmount: _parse(_productAmount),
          exchangeRate: _parse(_exchangeRate),
          serviceFee: _parse(_serviceFee),
          localDeliveryFee: _parse(_localDelivery),
        );
    context.go('/shopper');
  }

  @override
  Widget build(BuildContext context) {
    final request = ref
        .watch(adminRequestControllerProvider.notifier)
        .requestById(widget.requestId);

    if (request == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 672),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackLink(label: 'Back', onTap: () => context.go('/shopper')),
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
                    'Calculate Quote',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _RequestDetails(request: request),
                  const SizedBox(height: 24),
                  _FieldGrid(
                    breakpoint: _gridBreakpoint,
                    fields: [
                      AppTextField(
                        label: 'Product Amount',
                        controller: _productAmount,
                        keyboardType: TextInputType.number,
                      ),
                      AppTextField(
                        label: 'Exchange Rate',
                        controller: _exchangeRate,
                        keyboardType: TextInputType.number,
                      ),
                      AppTextField(
                        label: 'Service Fee',
                        controller: _serviceFee,
                        keyboardType: TextInputType.number,
                      ),
                      AppTextField(
                        label: 'Local Delivery',
                        controller: _localDelivery,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Generate & Send Quote',
                    onPressed: _submit,
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

class _RequestDetails extends StatelessWidget {
  const _RequestDetails({required this.request});

  final ProductRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Request Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Color(0xFFA1A1AA),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            request.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.3,
              color: AppColors.foreground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            request.url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.fields, required this.breakpoint});

  final List<Widget> fields;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            children: [
              for (var i = 0; i < fields.length; i++) ...[
                fields[i],
                if (i < fields.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < fields.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: fields[i]),
                  const SizedBox(width: 20),
                  Expanded(child: fields[i + 1]),
                ],
              ),
              if (i + 2 < fields.length) const SizedBox(height: 20),
            ],
          ],
        );
      },
    );
  }
}
