import 'package:flutter/material.dart';

import '../../features/requests/admin_request_models.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

/// Card used across staff workspaces (shopper, logistics) showing a request's
/// identity plus a context-specific [subtitle] and optional [action].
class StaffRequestCard extends StatelessWidget {
  const StaffRequestCard({
    required this.request,
    required this.subtitle,
    this.action,
    super.key,
  });

  final ProductRequest request;
  final Widget subtitle;
  final Widget? action;

  static const double _rowBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _rowBreakpoint;
          final details = _Details(request: request, subtitle: subtitle);
          final trailing = action;

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                details,
                if (trailing != null) ...[
                  const SizedBox(height: 24),
                  trailing,
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: details),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing,
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.request, required this.subtitle});

  final ProductRequest request;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              request.id,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: Color(0xFFA1A1AA),
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(status: request.status),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          request.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            height: 1.3,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 8),
        subtitle,
      ],
    );
  }
}
