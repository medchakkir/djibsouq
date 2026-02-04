import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalDots;
  final Color activeColor;
  final Color inactiveColor;
  final double spacing;

  const DotIndicator({
    super.key,
    required this.currentIndex,
    required this.totalDots,
    this.activeColor = const Color(0xFF1E3A8A),
    this.inactiveColor = const Color(0xFF1E3A8A),
    this.spacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing),
          height: 6,
          width: currentIndex == index ? 18 : 6,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? activeColor
                : inactiveColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
