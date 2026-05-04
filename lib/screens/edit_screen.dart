import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/mahasiswa_model.dart';
import '../services/firestore_service.dart';

class EditScreen extends StatefulWidget {
  final Mahasiswa mahasiswa;
  const EditScreen({super.key, required this.mahasiswa});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _nama, _nim, _tgl, _hobi, _hp, _alamat;
  File? _foto;
  bool _loading = false;
  final _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    final m = widget.mahasiswa;
    _nama = TextEditingController(text: m.nama);
    _nim = TextEditingController(text: m.nim);
    _tgl = TextEditingController(text: m.tanggalLahir);
    _hobi = TextEditingController(text: m.hobi);
    _hp = TextEditingController(text: m.nomorHp);
    _alamat = TextEditingController(text: m.alamat);
  }

  Future<void> _update() async {
    setState(() => _loading = true);
    try {
      String fotoUrl = widget.mahasiswa.fotoUrl;
      if (_foto != null) fotoUrl = await _service.uploadFoto(_foto!, _nim.text);
      final m = Mahasiswa(
        id: widget.mahasiswa.id, nama: _nama.text, nim: _nim.text,
        tanggalLahir: _tgl.text, hobi: _hobi.text,
        nomorHp: _hp.text, alamat: _alamat.text, fotoUrl: fotoUrl,
      );
      await _service.updateMahasiswa(m);
      Navigator.pop(context);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus data ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.deleteMahasiswa(widget.mahasiswa.id);
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mahasiswa'),
        actions: [IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _delete)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (picked != null) setState(() => _foto = File(picked.path));
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _foto != null
                  ? FileImage(_foto!) as ImageProvider
                  : (widget.mahasiswa.fotoUrl.isNotEmpty ? NetworkImage(widget.mahasiswa.fotoUrl) : null),
              child: (_foto == null && widget.mahasiswa.fotoUrl.isEmpty)
                  ? const Icon(Icons.add_a_photo, size: 36) : null,
            ),
          ),
          const SizedBox(height: 16),
          for (final entry in {
            'Nama Mahasiswa': _nama, 'NIM': _nim, 'Tanggal Lahir': _tgl,
            'Hobi': _hobi, 'Nomor HP': _hp, 'Alamat': _alamat,
          }.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: entry.value,
                decoration: InputDecoration(labelText: entry.key, border: const OutlineInputBorder()),
              ),
            ),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(onPressed: _update, child: const Text('Update')),
        ],
      ),
    );
  }
}