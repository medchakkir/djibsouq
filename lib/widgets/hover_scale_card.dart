import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  HOVER SCALE CARD
// ─────────────────────────────────────────────
class HoverScaleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleEnd;
  final Duration duration;

  const HoverScaleCard({
    super.key,
    required this.child,
    this.onTap,
    this.scaleEnd = 1.04,
    this.duration = const Duration(milliseconds: 250),
  });

  @override
  State<HoverScaleCard> createState() => _HoverScaleCardState();
}

class _HoverScaleCardState extends State<HoverScaleCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: 1, end: widget.scaleEnd)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}