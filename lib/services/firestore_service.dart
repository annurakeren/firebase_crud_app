import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/mahasiswa_model.dart';

class FirestoreService {
  final _collection =
  FirebaseFirestore.instance.collection('mahasiswa');

  Stream<List<Mahasiswa>> getMahasiswa() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Mahasiswa.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addMahasiswa(Mahasiswa mahasiswa) {
    return _collection.add(mahasiswa.toMap());
  }

  Future<void> updateMahasiswa(Mahasiswa mahasiswa) {
    return _collection.doc(mahasiswa.id).update(mahasiswa.toMap());
  }

  Future<void> deleteMahasiswa(String id) {
    return _collection.doc(id).delete();
  }
}