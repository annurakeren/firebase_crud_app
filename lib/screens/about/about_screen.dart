import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const AboutScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  Widget featureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.softCream,
            child: Icon(
              icon,
              color: AppColors.amberwood,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: AppColors.amberwood,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'SIM Data Mahasiswa',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aplikasi sederhana untuk mengelola data mahasiswa menggunakan Flutter dan Firebase.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Aplikasi',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  featureItem(
                    icon: Icons.login_rounded,
                    title: 'Login',
                    subtitle: 'Autentikasi pengguna dengan email dan password.',
                  ),
                  featureItem(
                    icon: Icons.dataset_rounded,
                    title: 'CRUD Data',
                    subtitle: 'Tambah, baca, update, dan hapus data mahasiswa.',
                  ),
                  featureItem(
                    icon: Icons.search_rounded,
                    title: 'Search & Filter',
                    subtitle: 'Cari berdasarkan nama/NIM dan filter berdasarkan hobi.',
                  ),
                  featureItem(
                    icon: Icons.image_rounded,
                    title: 'Upload Foto',
                    subtitle: 'Persiapan fitur upload foto mahasiswa.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: const Text('Ubah tema aplikasi'),
              value: isDarkMode,
              activeColor: AppColors.amberwood,
              onChanged: onThemeChanged,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'KUIS 4 Flutter Firebase 2026',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}