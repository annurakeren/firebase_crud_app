import 'package:flutter/material.dart';
import '../screens/detail/detail_screen.dart';
import '../theme/app_colors.dart';

class MahasiswaCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String tanggalLahir;
  final String hobi;
  final String nomorHp;
  final String alamat;

  const MahasiswaCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.tanggalLahir,
    required this.hobi,
    required this.nomorHp,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.softCream,
                child: Icon(
                  Icons.person_rounded,
                  color: AppColors.amberwood,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'NIM: $nim',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          size: 15,
                          color: AppColors.amberwood,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          hobi,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}