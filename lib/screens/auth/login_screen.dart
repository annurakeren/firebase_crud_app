import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('Lupa Password?'),
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardScreen(
                      isDarkMode: isDarkMode,
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}