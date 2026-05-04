import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/mahasiswa_model.dart';
import '../../services/firestore_service.dart';
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
  final FirestoreService _service = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final tanggalController = TextEditingController();
  final hobiController = TextEditingController();
  final hpController = TextEditingController();
  final alamatController = TextEditingController();

  File? _selectedImage;
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  String? nimValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'NIM wajib diisi';
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) return 'NIM hanya boleh angka';
    if (value.trim().length < 5) return 'NIM minimal 5 angka';
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor HP wajib diisi';
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) return 'Nomor HP hanya boleh angka';
    if (value.trim().length < 10) return 'Nomor HP minimal 10 angka';
    return null;
  }

  Future<void> saveMahasiswa() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final mahasiswa = Mahasiswa(
        id: '',
        nama: namaController.text.trim(),
        nim: nimController.text.trim(),
        tanggalLahir: tanggalController.text.trim(),
        hobi: hobiController.text.trim(),
        nomorHp: hpController.text.trim(),
        alamat: alamatController.text.trim(),
        fotoUrl: _selectedImage?.path ?? '',
      );

      await _service.addMahasiswa(mahasiswa);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data mahasiswa berhasil ditambahkan.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: AppColors.softCream,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(
                        Icons.person_rounded,
                        size: 54,
                        color: AppColors.amberwood,
                      )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.amberwood,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: _pickImage,
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
                          validator: (v) => requiredValidator(v, 'Nama mahasiswa'),
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
                          validator: (v) => requiredValidator(v, 'Tanggal lahir'),
                        ),
                        CustomTextField(
                          controller: hobiController,
                          label: 'Hobi',
                          icon: Icons.favorite_rounded,
                          validator: (v) => requiredValidator(v, 'Hobi'),
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
                          validator: (v) => requiredValidator(v, 'Alamat'),
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: isLoading ? 'Menyimpan...' : 'Simpan Data',
                          icon: Icons.save_rounded,
                          onPressed: isLoading ? null : saveMahasiswa,
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
                child: CircularProgressIndicator(color: AppColors.amberwood),
              ),
            ),
        ],
      ),
    );
  }
}