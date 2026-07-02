import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/staff_request_card.dart';
import '../../shared/widgets/status_badge.dart';
import '../requests/admin_request_controller.dart';
import '../requests/admin_request_models.dart';

/// Shopper workspace listing requests to quote and purchase, mirroring the
/// designer `ShopperDashboard`.
class ShopperTasksScreen extends ConsumerWidget {
  const ShopperTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(adminRequestControllerProvider);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 768),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(),
            const SizedBox(height: 40),
            for (final request in requests) ...[
              StaffRequestCard(
                request: request,
                subtitle: _UrlSubtitle(url: request.url),
                action: _ShopperAction(request: request),
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
          'Shopper Tasks',
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
          'Manage pending requests and active orders.',
          style: TextStyle(fontSize: 18, color: AppColors.mutedForeground),
        ),
      ],
    );
  }
}

class _UrlSubtitle extends StatelessWidget {
  const _UrlSubtitle({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Text(
      url,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 15, color: AppColors.mutedForeground),
    );
  }
}

class _ShopperAction extends ConsumerWidget {
  const _ShopperAction({required this.request});

  final ProductRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (request.status == OrderStatus.submitted) {
      return AppButton(
        label: 'Create Quote',
        onPressed: () => context.go('/quotes/${request.id}/create'),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      );
    }

    if (request.status == OrderStatus.paid) {
      return AppButton(
        label: 'Mark Purchased',
        variant: AppButtonVariant.secondary,
        onPressed: () => ref
            .read(adminRequestControllerProvider.notifier)
            .markPurchased(request.id),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        radius: 16,
      );
    }

    return const SizedBox.shrink();
  }
}
