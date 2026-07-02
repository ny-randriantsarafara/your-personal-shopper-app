import 'package:flutter/material.dart';

import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/status_badge.dart';
import '../../shared/widgets/tracking_progress.dart';
import 'order_models.dart';

/// A single order row on the customer dashboard, mirroring the designer client
/// cards. [highlighted] renders the attention (blue-bordered) treatment and
/// [trailing] carries the status-specific action or summary.
class OrderCard extends StatelessWidget {
  const OrderCard({
    required this.request,
    required this.trailing,
    this.highlighted = false,
    this.showTracking = false,
    super.key,
  });

  final ProductRequest request;
  final Widget trailing;
  final bool highlighted;
  final bool showTracking;

  static const double _rowBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: highlighted ? const Color(0xFFDBEAFE) : AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= _rowBreakpoint;
          final details = _Details(request: request, showTracking: showTracking);

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Thumbnail(imageUrl: request.imageUrl),
                const SizedBox(height: 20),
                details,
                const SizedBox(height: 16),
                Align(alignment: Alignment.centerLeft, child: trailing),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: _Thumbnail(imageUrl: request.imageUrl),
              ),
              const SizedBox(width: 24),
              Expanded(child: details),
              const SizedBox(width: 24),
              trailing,
            ],
          );
        },
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0x08000000)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: (url != null && url.isNotEmpty)
              ? Image.network(url, fit: BoxFit.cover)
              : const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 32,
                    color: Color(0xFFD4D4D8),
                  ),
                ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.request, required this.showTracking});

  final ProductRequest request;
  final bool showTracking;

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
        const SizedBox(height: 8),
        Text(
          request.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.3,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                request.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.mutedForeground,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 14,
              color: Color(0x80A1A1AA),
            ),
          ],
        ),
        if (showTracking) TrackingProgress(status: request.status),
      ],
    );
  }
}
