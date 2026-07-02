import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/back_link.dart';
import '../orders/order_controller.dart';

/// Form for submitting a new purchase request, mirroring the designer
/// `NewRequestForm`.
class NewRequestScreen extends ConsumerStatefulWidget {
  const NewRequestScreen({super.key});

  @override
  ConsumerState<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends ConsumerState<NewRequestScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _budgetController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    if (title.isEmpty || url.isEmpty) {
      return;
    }
    ref.read(orderControllerProvider.notifier).createRequest(
      title: title,
      url: url,
    );
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 672),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BackLink(
              label: 'Back to Requests',
              onTap: () => context.go('/'),
            ),
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
                    'What would you like to buy?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextField(
                    label: 'Product Name',
                    controller: _titleController,
                    hint: 'e.g. Wireless Headphones',
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'Product Link (URL)',
                    controller: _urlController,
                    hint: 'https://...',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    label: 'Max Budget (Optional, EUR/USD)',
                    controller: _budgetController,
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: 'Submit Request',
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
