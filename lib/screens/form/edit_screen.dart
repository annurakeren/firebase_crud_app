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
  final formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController nimController;
  late TextEditingController tanggalController;
  late TextEditingController hobiController;
  late TextEditingController hpController;
  late TextEditingController alamatController;

  bool isLoading = false;

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

  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  String? nimValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'NIM wajib diisi';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'NIM hanya boleh angka';
    }

    if (value.trim().length < 5) {
      return 'NIM minimal 5 angka';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Nomor HP hanya boleh angka';
    }

    if (value.trim().length < 10) {
      return 'Nomor HP minimal 10 angka';
    }

    return null;
  }

  Future<void> updateDummy() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

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
            onPressed: () async {
              Navigator.pop(context);

              setState(() {
                isLoading = true;
              });

              await Future.delayed(const Duration(seconds: 1));

              if (!mounted) return;

              setState(() {
                isLoading = false;
              });

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
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 80.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: namaController,
                          label: 'Nama Mahasiswa',
                          icon: Icons.person_rounded,
                          validator: (value) =>
                              requiredValidator(value, 'Nama mahasiswa'),
                        ),
                        CustomTextField(
                          controller: nimController,
                          label: 'NIM',
                          icon: Icons.badge_rounded,
                          keyboardType: TextInputType.number,
                          validator: nimValidator,
                        ),
                        CustomTextField(
                          controller: tanggalController,
                          label: 'Tanggal Lahir',
                          icon: Icons.calendar_month_rounded,
                          validator: (value) =>
                              requiredValidator(value, 'Tanggal lahir'),
                        ),
                        CustomTextField(
                          controller: hobiController,
                          label: 'Hobi',
                          icon: Icons.favorite_rounded,
                          validator: (value) =>
                              requiredValidator(value, 'Hobi'),
                        ),
                        CustomTextField(
                          controller: hpController,
                          label: 'Nomor HP',
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                          validator: phoneValidator,
                        ),
                        CustomTextField(
                          controller: alamatController,
                          label: 'Alamat',
                          icon: Icons.home_rounded,
                          maxLines: 2,
                          validator: (value) =>
                              requiredValidator(value, 'Alamat'),
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: isLoading ? 'Mengupdate...' : 'Update Data',
                          icon: Icons.update_rounded,
                          onPressed: isLoading ? null : updateDummy,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isLoading ? null : confirmDelete,
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
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.15),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.amberwood,
                ),
              ),
            ),
        ],
      ),
    );
  }
}