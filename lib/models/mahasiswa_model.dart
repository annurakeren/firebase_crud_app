class Mahasiswa {
  final String id;
  final String nama;
  final String nim;
  final String tanggalLahir;
  final String hobi;
  final String nomorHp;
  final String alamat;
  final String fotoUrl;

  Mahasiswa({
    required this.id,
    required this.nama,
    required this.nim,
    required this.tanggalLahir,
    required this.hobi,
    required this.nomorHp,
    required this.alamat,
    required this.fotoUrl,
  });

  factory Mahasiswa.fromMap(String id, Map<String, dynamic> map) {
    return Mahasiswa(
      id: id,
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
      tanggalLahir: map['tanggalLahir'] ?? '',
      hobi: map['hobi'] ?? '',
      nomorHp: map['nomorHp'] ?? '',
      alamat: map['alamat'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'nama': nama, 'nim': nim, 'tanggalLahir': tanggalLahir,
    'hobi': hobi, 'nomorHp': nomorHp, 'alamat': alamat, 'fotoUrl': fotoUrl,
  };
}