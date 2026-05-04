import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final namaController = TextEditingController(text: 'Annura Rizkya');
    final nimController = TextEditingController(text: '123456');

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Mahasiswa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(controller: namaController, label: 'Nama', icon: Icons.person),
          CustomTextField(controller: nimController, label: 'NIM', icon: Icons.badge),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Update',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Hapus Data?'),
                  content: const Text('Data yang dihapus tidak bisa dikembalikan.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}