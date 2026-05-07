import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? seeAllText;
  final VoidCallback? onSeeAllPressed;
  final TextStyle? titleStyle;
  final TextStyle? seeAllStyle;

  const SectionTitle({
    super.key,
    required this.title,
    this.seeAllText,
    this.onSeeAllPressed,
    this.titleStyle,
    this.seeAllStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
        ),
        if (seeAllText != null)
          TextButton(
            onPressed: onSeeAllPressed,
            child: Text(
              seeAllText!,
              style:
                  seeAllStyle ??
                  const TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
      ],
    );
  }
}
