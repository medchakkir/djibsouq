import 'package:flutter/material.dart';

/// App Color Palette
class AppColors {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color cardGrey = Color(0xFFE5E7EB);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFF43F5E);
  static const Color purpleAccent = Color(0xFF8B5CF6);
  static const Color pinkAccent = Color(0xFFEC4899);
}

/// App Text Styles
class AppTextStyles {
  static const TextStyle largeTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle normalText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

/// App Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

/// App Border Radius
class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double full = 24.0;
}
