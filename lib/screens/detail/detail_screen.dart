import 'package:flutter/material.dart';
import '../form/edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;

  const DetailScreen({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Nama: $nama'),
                Text('NIM: $nim'),
                const Text('Tanggal Lahir: 01 Januari 2000'),
                Text('Hobi: $hobi'),
                const Text('Nomor HP: 08123456789'),
                const Text('Alamat: Depok'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditScreen()),
                    );
                  },
                  child: const Text('Edit Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}