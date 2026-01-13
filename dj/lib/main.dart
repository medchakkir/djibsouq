import 'package:flutter/material.dart';
import 'pages/homepage.dart';

const Color primaryBlue = Color(0xFF1E3A8A);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DJIBSOUQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryBlue,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryBlue),
          titleTextStyle: TextStyle(
            color: primaryBlue,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
