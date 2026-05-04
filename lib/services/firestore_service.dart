import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/mahasiswa_model.dart';

class FirestoreService {
  final _col = FirebaseFirestore.instance.collection('mahasiswa');
  final _storage = FirebaseStorage.instance;

  Stream<List<Mahasiswa>> getMahasiswaStream() {
    return _col.orderBy('nama').snapshots().map((snap) =>
        snap.docs.map((d) => Mahasiswa.fromMap(d.id, d.data())).toList());
  }

  Future<void> addMahasiswa(Mahasiswa m) => _col.add(m.toMap());

  Future<void> updateMahasiswa(Mahasiswa m) => _col.doc(m.id).update(m.toMap());

  Future<void> deleteMahasiswa(String id) => _col.doc(id).delete();

  Future<String> uploadFoto(File file, String nim) async {
    final ref = _storage.ref().child('foto_mahasiswa/$nim.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}