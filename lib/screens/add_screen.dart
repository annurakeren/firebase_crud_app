import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/mahasiswa_model.dart';
import '../services/firestore_service.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nama = TextEditingController();
  final _nim = TextEditingController();
  final _tgl = TextEditingController();
  final _hobi = TextEditingController();
  final _hp = TextEditingController();
  final _alamat = TextEditingController();
  File? _foto;
  bool _loading = false;
  final _service = FirestoreService();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _foto = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      String fotoUrl = '';
      if (_foto != null) fotoUrl = await _service.uploadFoto(_foto!, _nim.text);
      final m = Mahasiswa(
        id: '', nama: _nama.text, nim: _nim.text,
        tanggalLahir: _tgl.text, hobi: _hobi.text,
        nomorHp: _hp.text, alamat: _alamat.text, fotoUrl: fotoUrl,
      );
      await _service.addMahasiswa(m);
      Navigator.pop(context);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _foto != null ? FileImage(_foto!) : null,
                child: _foto == null ? const Icon(Icons.add_a_photo, size: 36) : null,
              ),
            ),
            const SizedBox(height: 16),
            _field(_nama, 'Nama Mahasiswa', validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            _field(_nim, 'NIM', keyboardType: TextInputType.number,
                validator: (v) => v!.length < 8 ? 'NIM minimal 8 digit' : null),
            _field(_tgl, 'Tanggal Lahir (DD/MM/YYYY)', validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            _field(_hobi, 'Hobi', validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            _field(_hp, 'Nomor HP', keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            _field(_alamat, 'Alamat', maxLines: 3, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: 16),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {TextInputType? keyboardType, int maxLines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: validator,
      ),
    );
  }
}