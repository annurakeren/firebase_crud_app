import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SplashScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            isDarkMode: isDarkMode,
            onThemeChanged: onThemeChanged,
          ),
        ),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text(
          'Firebase CRUD App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}