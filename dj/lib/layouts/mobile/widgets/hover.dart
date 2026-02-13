import 'package:flutter/material.dart';

class HoverContainer extends StatefulWidget {
  final Widget child;
  final double translateY;

  const HoverContainer({
    Key? key,
    required this.child,
    this.translateY = -5,
  }) : super(key: key);

  @override
  State<HoverContainer> createState() => _HoverContainerState();
}

class _HoverContainerState extends State<HoverContainer> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: isHover
            ? (Matrix4.identity()..translate(0, widget.translateY))
            : Matrix4.identity(),
        child: widget.child,
      ),
    );
  }
}
