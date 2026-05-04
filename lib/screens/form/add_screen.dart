import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final tanggalController = TextEditingController();
  final hobiController = TextEditingController();
  final hpController = TextEditingController();
  final alamatController = TextEditingController();

  bool isLoading = false;

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

  Future<void> saveDummy() async {
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
        content: Text('Data mahasiswa dummy berhasil ditambahkan.'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 80.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data'),
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
                'Tambah Mahasiswa',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Lengkapi form data mahasiswa di bawah ini.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    const CircleAvatar(
                      radius: 54,
                      backgroundColor: AppColors.softCream,
                      child: Icon(
                        Icons.person_rounded,
                        size: 54,
                        color: AppColors.amberwood,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.amberwood,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
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
                          text: isLoading ? 'Menyimpan...' : 'Simpan Data',
                          icon: Icons.save_rounded,
                          onPressed: isLoading ? null : saveDummy,
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
              color: Colors.black.withValues(alpha: 0.15),
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