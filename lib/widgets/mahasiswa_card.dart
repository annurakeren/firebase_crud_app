import 'dart:io';
import 'package:flutter/material.dart';

import '../models/mahasiswa_model.dart';
import '../screens/detail/detail_screen.dart';
import '../theme/app_colors.dart';

class MahasiswaCard extends StatelessWidget {
  final Mahasiswa mahasiswa;

  const MahasiswaCard({
    super.key,
    required this.mahasiswa,
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
                mahasiswa: mahasiswa,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.softCream,
                backgroundImage: mahasiswa.fotoUrl.isNotEmpty
                    ? (mahasiswa.fotoUrl.startsWith('http')
                        ? NetworkImage(mahasiswa.fotoUrl)
                        : FileImage(File(mahasiswa.fotoUrl)) as ImageProvider)
                    : null,
                child: mahasiswa.fotoUrl.isEmpty
                    ? const Icon(
                  Icons.person_rounded,
                  color: AppColors.amberwood,
                  size: 32,
                )
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mahasiswa.nama,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'NIM: ${mahasiswa.nim}',
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
                        Expanded(
                          child: Text(
                            mahasiswa.hobi,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
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