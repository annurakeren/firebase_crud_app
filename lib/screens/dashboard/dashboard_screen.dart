import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/filter_chip_widget.dart';
import '../../widgets/mahasiswa_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../about/about_screen.dart';
import '../form/add_screen.dart';

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DashboardScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedHobi = 'Semua';
  String searchQuery = '';
  bool sortByName = false;

  final List<Map<String, String>> dummyData = [
    {
      'nama': 'Annura Rizkya',
      'nim': '240001',
      'tanggalLahir': '14 April 2005',
      'hobi': 'Membaca',
      'nomorHp': '081234567890',
      'alamat': 'Depok',
    },
    {
      'nama': 'Budi Santoso',
      'nim': '240002',
      'tanggalLahir': '21 Mei 2005',
      'hobi': 'Musik',
      'nomorHp': '081298765432',
      'alamat': 'Jakarta',
    },
    {
      'nama': 'Citra Lestari',
      'nim': '240003',
      'tanggalLahir': '09 Agustus 2005',
      'hobi': 'Olahraga',
      'nomorHp': '081377788899',
      'alamat': 'Bogor',
    },
  ];

  List<Map<String, String>> get filteredData {
    List<Map<String, String>> result = dummyData.where((data) {
      final nama = data['nama']!.toLowerCase();
      final nim = data['nim']!.toLowerCase();
      final hobi = data['hobi']!;

      final matchSearch = nama.contains(searchQuery.toLowerCase()) ||
          nim.contains(searchQuery.toLowerCase());

      final matchHobi = selectedHobi == 'Semua' || hobi == selectedHobi;

      return matchSearch && matchHobi;
    }).toList();

    if (sortByName) {
      result.sort((a, b) => a['nama']!.compareTo(b['nama']!));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Sort Nama',
            icon: Icon(
              sortByName
                  ? Icons.sort_by_alpha_rounded
                  : Icons.sort_rounded,
            ),
            onPressed: () {
              setState(() {
                sortByName = !sortByName;
              });
            },
          ),
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AboutScreen(
                    isDarkMode: widget.isDarkMode,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Data Mahasiswa',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Cari, filter, dan kelola data mahasiswa.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SearchBarWidget(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: 'Semua',
                  selected: selectedHobi == 'Semua',
                  onSelected: () {
                    setState(() {
                      selectedHobi = 'Semua';
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Membaca',
                  selected: selectedHobi == 'Membaca',
                  onSelected: () {
                    setState(() {
                      selectedHobi = 'Membaca';
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Musik',
                  selected: selectedHobi == 'Musik',
                  onSelected: () {
                    setState(() {
                      selectedHobi = 'Musik';
                    });
                  },
                ),
                FilterChipWidget(
                  label: 'Olahraga',
                  selected: selectedHobi == 'Olahraga',
                  onSelected: () {
                    setState(() {
                      selectedHobi = 'Olahraga';
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.amberwood,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    '${data.length} data mahasiswa ditampilkan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (data.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  const Text('Data tidak ditemukan'),
                ],
              ),
            )
          else
            ...data.map(
              (item) => MahasiswaCard(
                nama: item['nama']!,
                nim: item['nim']!,
                tanggalLahir: item['tanggalLahir']!,
                hobi: item['hobi']!,
                nomorHp: item['nomorHp']!,
                alamat: item['alamat']!,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
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