import 'package:flutter/material.dart';
import '../screens/detail/detail_screen.dart';

class MahasiswaCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String hobi;

  const MahasiswaCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.hobi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(nama),
        subtitle: Text('NIM: $nim\nHobi: $hobi'),
        isThreeLine: true,
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
                nama: nama,
                nim: nim,
                hobi: hobi,
              ),
            ),
          );
        },
      ),
    );
  }
}