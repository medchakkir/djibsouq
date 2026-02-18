import 'package:dj/demarrage_screen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DemarrageScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
