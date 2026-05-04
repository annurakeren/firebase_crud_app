import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/mahasiswa_model.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;

  const EditScreen({
    super.key,
    required this.mahasiswa,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  final FirestoreService _service = FirestoreService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController namaController;
  late TextEditingController nimController;
  late TextEditingController tanggalController;
  late TextEditingController hobiController;
  late TextEditingController hpController;
  late TextEditingController alamatController;

  File? _selectedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final m = widget.mahasiswa;
    namaController = TextEditingController(text: m.nama);
    nimController = TextEditingController(text: m.nim);
    tanggalController = TextEditingController(text: m.tanggalLahir);
    hobiController = TextEditingController(text: m.hobi);
    hpController = TextEditingController(text: m.nomorHp);
    alamatController = TextEditingController(text: m.alamat);
    
    if (m.fotoUrl.isNotEmpty && !m.fotoUrl.startsWith('http')) {
      _selectedImage = File(m.fotoUrl);
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
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
    if (value == null || value.trim().isEmpty) return '$fieldName wajib diisi';
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

  Future<void> updateMahasiswa() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final updated = Mahasiswa(
        id: widget.mahasiswa.id,
        nama: namaController.text.trim(),
        nim: nimController.text.trim(),
        tanggalLahir: tanggalController.text.trim(),
        hobi: hobiController.text.trim(),
        nomorHp: hpController.text.trim(),
        alamat: alamatController.text.trim(),
        fotoUrl: _selectedImage?.path ?? widget.mahasiswa.fotoUrl,
        createdAt: widget.mahasiswa.createdAt,
      );

      await _service.updateMahasiswa(updated);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diupdate.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update data: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
              Navigator.pop(context); // tutup dialog

              setState(() => isLoading = true);

              try {
                await _service.deleteMahasiswa(widget.mahasiswa.id);

                if (!mounted) return;

                // pop edit screen + detail screen, kembali ke dashboard
                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil dihapus.')),
                );
              } catch (e) {
                if (!mounted) return;
                setState(() => isLoading = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus data: $e')),
                );
              }
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
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: AppColors.softCream,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (widget.mahasiswa.fotoUrl.startsWith('http')
                              ? NetworkImage(widget.mahasiswa.fotoUrl)
                              : null as ImageProvider?),
                      child: _selectedImage == null &&
                              !widget.mahasiswa.fotoUrl.startsWith('http')
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
                          text: isLoading ? 'Mengupdate...' : 'Update Data',
                          icon: Icons.update_rounded,
                          onPressed: isLoading ? null : updateMahasiswa,
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
                child: CircularProgressIndicator(color: AppColors.amberwood),
              ),
            ),
        ],
      ),
    );
  }
}