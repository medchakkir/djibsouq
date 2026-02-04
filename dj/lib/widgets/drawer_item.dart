import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final TextStyle? labelStyle;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.iconColor,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? const Color(0xFF1E3A8A)),
      title: Text(
        label,
        style:
            labelStyle ??
            const TextStyle(
              color: Color(0xFF1E3A8A),
              fontWeight: FontWeight.w500,
            ),
      ),
      onTap: onPressed,
    );
  }
}
