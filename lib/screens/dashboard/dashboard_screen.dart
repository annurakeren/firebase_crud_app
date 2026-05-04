import 'package:flutter/material.dart';

import '../../models/mahasiswa_model.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/mahasiswa_card.dart';
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
  final FirestoreService _service = FirestoreService();
  final searchController = TextEditingController();

  String searchQuery = '';
  String filterHobi = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Mahasiswa> _applyFilter(List<Mahasiswa> list) {
    return list.where((m) {
      final matchSearch = searchQuery.isEmpty ||
          m.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
          m.nim.toLowerCase().contains(searchQuery.toLowerCase());

      final matchHobi = filterHobi.isEmpty ||
          m.hobi.toLowerCase().contains(filterHobi.toLowerCase());

      return matchSearch && matchHobi;
    }).toList();
  }

  void showFilterDialog(List<Mahasiswa> allData) {
    final hobiList = allData.map((m) => m.hobi).toSet().toList();
    hobiList.sort();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filter Hobi'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Semua'),
                leading: Radio<String>(
                  value: '',
                  groupValue: filterHobi,
                  activeColor: AppColors.amberwood,
                  onChanged: (v) {
                    setState(() => filterHobi = v!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ...hobiList.map(
                    (hobi) => ListTile(
                  title: Text(hobi),
                  leading: Radio<String>(
                    value: hobi,
                    groupValue: filterHobi,
                    activeColor: AppColors.amberwood,
                    onChanged: (v) {
                      setState(() => filterHobi = v!);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIM Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AboutScreen(
                  isDarkMode: widget.isDarkMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Mahasiswa>>(
        stream: _service.getMahasiswa(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.amberwood,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final allData = snapshot.data ?? [];
          final filtered = _applyFilter(allData);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama atau NIM...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              searchController.clear();
                              setState(() => searchQuery = '');
                            },
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                        onChanged: (v) => setState(() => searchQuery = v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: () => showFilterDialog(allData),
                      icon: Stack(
                        children: [
                          const Icon(Icons.filter_list_rounded),
                          if (filterHobi.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.danger,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.amberwood,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              if (filterHobi.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text('Filter: '),
                      Chip(
                        label: Text(filterHobi),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => filterHobi = ''),
                        backgroundColor: AppColors.softCream,
                      ),
                    ],
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      '${filtered.length} mahasiswa',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: filtered.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: AppColors.mutedText.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        allData.isEmpty
                            ? 'Belum ada data mahasiswa.'
                            : 'Data tidak ditemukan.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final m = filtered[index];

                    return MahasiswaCard(
                      mahasiswa: m,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddScreen(),
          ),
        ),
        backgroundColor: AppColors.amberwood,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
    );
  }
}