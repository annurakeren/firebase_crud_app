import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditScreen extends StatefulWidget {
  final String nama;
  final String nim;
  final String tanggalLahir;
  final String hobi;
  final String nomorHp;
  final String alamat;

  const EditScreen({
    super.key,
    required this.nama,
    required this.nim,
    required this.tanggalLahir,
    required this.hobi,
    required this.nomorHp,
    required this.alamat,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController namaController;
  late TextEditingController nimController;
  late TextEditingController tanggalController;
  late TextEditingController hobiController;
  late TextEditingController hpController;
  late TextEditingController alamatController;

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(text: widget.nama);
    nimController = TextEditingController(text: widget.nim);
    tanggalController = TextEditingController(text: widget.tanggalLahir);
    hobiController = TextEditingController(text: widget.hobi);
    hpController = TextEditingController(text: widget.nomorHp);
    alamatController = TextEditingController(text: widget.alamat);
  }

  @override
  void dispose() {
    namaController.dispose();
    nimController.dispose();
    tanggalController.dispose();
    hobiController.dispose();
    hpController.dispose();
    alamatController.dispose();
    super.dispose();
  }

  void updateDummy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data dummy berhasil diupdate.'),
      ),
    );

    Navigator.pop(context);
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Data?'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus data ini? Data yang dihapus tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data dummy berhasil dihapus.'),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Edit Mahasiswa',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Ubah data mahasiswa atau hapus data.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  CustomTextField(
                    controller: namaController,
                    label: 'Nama Mahasiswa',
                    icon: Icons.person_rounded,
                  ),
                  CustomTextField(
                    controller: nimController,
                    label: 'NIM',
                    icon: Icons.badge_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextField(
                    controller: tanggalController,
                    label: 'Tanggal Lahir',
                    icon: Icons.calendar_month_rounded,
                  ),
                  CustomTextField(
                    controller: hobiController,
                    label: 'Hobi',
                    icon: Icons.favorite_rounded,
                  ),
                  CustomTextField(
                    controller: hpController,
                    label: 'Nomor HP',
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  CustomTextField(
                    controller: alamatController,
                    label: 'Alamat',
                    icon: Icons.home_rounded,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Update Data',
                    icon: Icons.update_rounded,
                    onPressed: updateDummy,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: confirmDelete,
                      icon: const Icon(Icons.delete_rounded),
                      label: const Text('Delete Data'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger,
                        side: const BorderSide(color: AppColors.danger),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}