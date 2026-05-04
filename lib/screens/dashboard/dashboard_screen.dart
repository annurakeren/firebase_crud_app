import 'package:flutter/material.dart';
import '../../widgets/mahasiswa_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/filter_chip_widget.dart';
import '../about/about_screen.dart';
import '../form/add_screen.dart';

class DashboardScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {
        'nama': 'Annura Rizkya',
        'nim': '123456',
        'hobi': 'Membaca',
      },
      {
        'nama': 'Budi Santoso',
        'nim': '654321',
        'hobi': 'Musik',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AboutScreen(
                    isDarkMode: isDarkMode,
                    onThemeChanged: onThemeChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchBarWidget(onChanged: (value) {}),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: const [
              FilterChipWidget(label: 'Semua'),
              FilterChipWidget(label: 'Membaca'),
              FilterChipWidget(label: 'Musik'),
            ],
          ),
          const SizedBox(height: 16),
          ...dummyData.map(
            (data) => MahasiswaCard(
              nama: data['nama']!,
              nim: data['nim']!,
              hobi: data['hobi']!,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddScreen()),
          );
        },
      ),
    );
  }
}