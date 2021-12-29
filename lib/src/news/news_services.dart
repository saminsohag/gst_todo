import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewsServices {
  Future<void> deleteNews(
      DocumentReference<Map<String, dynamic>> reference) async {
    FirebaseStorage.instance
        .ref()
        .child("news")
        .child(reference.id)
        .listAll()
        .then((value) {
      for (var eatch in value.items) {
        eatch.delete();
      }
    });
    reference.delete();
  }
}
