import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../form/edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String nim;
  final String tanggalLahir;
  final String hobi;
  final String nomorHp;
  final String alamat;

  const DetailScreen({
    super.key,
    required this.nama,
    required this.nim,
    required this.tanggalLahir,
    required this.hobi,
    required this.nomorHp,
    required this.alamat,
  });

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.softCream,
            child: Icon(
              icon,
              size: 18,
              color: AppColors.amberwood,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
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
        title: const Text('Detail Mahasiswa'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 54,
                    backgroundColor: AppColors.softCream,
                    child: Icon(
                      Icons.person_rounded,
                      size: 58,
                      color: AppColors.amberwood,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    nama,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM $nim',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  infoItem(
                    icon: Icons.badge_rounded,
                    title: 'NIM',
                    value: nim,
                  ),
                  infoItem(
                    icon: Icons.cake_rounded,
                    title: 'Tanggal Lahir',
                    value: tanggalLahir,
                  ),
                  infoItem(
                    icon: Icons.favorite_rounded,
                    title: 'Hobi',
                    value: hobi,
                  ),
                  infoItem(
                    icon: Icons.phone_rounded,
                    title: 'Nomor HP',
                    value: nomorHp,
                  ),
                  infoItem(
                    icon: Icons.home_rounded,
                    title: 'Alamat',
                    value: alamat,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditScreen(
                    nama: nama,
                    nim: nim,
                    tanggalLahir: tanggalLahir,
                    hobi: hobi,
                    nomorHp: nomorHp,
                    alamat: alamat,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Data'),
          ),
        ],
      ),
    );
  }
}