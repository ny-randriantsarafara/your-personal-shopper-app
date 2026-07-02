import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/format/number_format.dart';
import '../../shared/motion/staggered_entry.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/status_badge.dart';
import '../requests/admin_request_controller.dart';
import '../requests/admin_request_models.dart';
import 'admin_metric_card.dart';

/// Platform overview for the admin workspace, mirroring the designer
/// `AdminDashboard`.
class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key});

  static const double _gridBreakpoint = 640;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(adminRequestControllerProvider);
    final deliveredCount = requests
        .where((request) => request.status == OrderStatus.delivered)
        .length;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 896),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _OverviewHeader(),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                final cards = [
                  AdminMetricCard(
                    icon: Icons.description_outlined,
                    label: 'Total Requests',
                    value: '${requests.length}',
                  ),
                  AdminMetricCard(
                    icon: Icons.trending_up,
                    label: 'Delivered',
                    value: '$deliveredCount',
                  ),
                  const AdminMetricCard(
                    icon: Icons.people_outline,
                    label: 'Active Users',
                    value: '12',
                  ),
                ];

                if (constraints.maxWidth < _gridBreakpoint) {
                  return Column(
                    children: [
                      for (final card in cards) ...[
                        card,
                        if (card != cards.last) const SizedBox(height: 20),
                      ],
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      Expanded(child: cards[i]),
                      if (i < cards.length - 1) const SizedBox(width: 20),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'All Platform Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                color: AppColors.foreground,
              ),
            ),
            const SizedBox(height: 20),
            for (final (index, request) in requests.indexed) ...[
              StaggeredEntry(
                index: index,
                child: _PlatformRequestRow(request: request),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x0A111113))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Admin Overview',
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
            'Platform metrics and global requests.',
            style: TextStyle(fontSize: 18, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _PlatformRequestRow extends StatelessWidget {
  const _PlatformRequestRow({required this.request});

  final ProductRequest request;

  @override
  Widget build(BuildContext context) {
    final quote = request.quote;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      request.id,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Color(0xFFA1A1AA),
                      ),
                    ),
                    const SizedBox(width: 12),
                    StatusBadge(status: request.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  request.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            quote != null
                ? '${groupThousands(quote.totalMGA)} MGA'
                : 'No quote yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: quote != null ? FontWeight.w500 : FontWeight.w400,
              color: quote != null
                  ? AppColors.foreground
                  : const Color(0xFFA1A1AA),
            ),
          ),
        ],
      ),
    );
  }
}
