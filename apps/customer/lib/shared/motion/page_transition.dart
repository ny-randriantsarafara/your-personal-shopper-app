import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Entry transition for full pages, mirroring the designer motion:
/// opacity 0 -> 1, y 12 -> 0, scale .99 -> 1 over 400ms.
class PageFadeSlideTransition extends StatefulWidget {
  const PageFadeSlideTransition({super.key, required this.child});

  final Widget child;

  @override
  State<PageFadeSlideTransition> createState() =>
      _PageFadeSlideTransitionState();
}

class _PageFadeSlideTransitionState extends State<PageFadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.pageTransition,
  )..forward();

  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: AnimatedBuilder(
        animation: _curve,
        builder: (context, child) {
          final progress = _curve.value;
          final offsetY = 12 * (1 - progress);
          final scale = 0.99 + 0.01 * progress;
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: Transform.scale(scale: scale, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}
