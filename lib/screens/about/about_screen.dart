import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const AboutScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.school, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Firebase CRUD App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aplikasi sederhana untuk melakukan CRUD data mahasiswa menggunakan Flutter dan Firebase.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: onThemeChanged,
            ),
          ],
        ),
      ),
    );
  }
}