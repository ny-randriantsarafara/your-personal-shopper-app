import 'package:flutter/material.dart';

/// Card entry transition with an index-based delay, mirroring the designer
/// stagger: opacity 0 -> 1, y 15 -> 0, 80ms per item.
class StaggeredEntry extends StatefulWidget {
  const StaggeredEntry({
    super.key,
    required this.index,
    required this.child,
    this.staggerStep = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 400),
  });

  final int index;
  final Widget child;
  final Duration staggerStep;
  final Duration duration;

  @override
  State<StaggeredEntry> createState() => _StaggeredEntryState();
}

class _StaggeredEntryState extends State<StaggeredEntry>
    with SingleTickerProviderStateMixin {
  late final Duration _delay = widget.staggerStep * widget.index;
  late final Duration _total = _delay + widget.duration;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  )..forward();

  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _total.inMicroseconds == 0
          ? 0
          : _delay.inMicroseconds / _total.inMicroseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
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
          final offsetY = 15 * (1 - _curve.value);
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
