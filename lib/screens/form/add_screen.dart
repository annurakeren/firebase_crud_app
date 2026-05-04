import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final namaController = TextEditingController();
    final nimController = TextEditingController();
    final tanggalController = TextEditingController();
    final hobiController = TextEditingController();
    final hpController = TextEditingController();
    final alamatController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 45,
            child: Icon(Icons.camera_alt, size: 35),
          ),
          const SizedBox(height: 16),
          CustomTextField(controller: namaController, label: 'Nama', icon: Icons.person),
          CustomTextField(controller: nimController, label: 'NIM', icon: Icons.badge),
          CustomTextField(controller: tanggalController, label: 'Tanggal Lahir', icon: Icons.date_range),
          CustomTextField(controller: hobiController, label: 'Hobi', icon: Icons.favorite),
          CustomTextField(controller: hpController, label: 'Nomor HP', icon: Icons.phone),
          CustomTextField(controller: alamatController, label: 'Alamat', icon: Icons.home),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Simpan',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}