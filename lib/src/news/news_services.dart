import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewsServices {
  Future<void> deleteNews(
      DocumentReference<Map<String, dynamic>> reference) async {
    await reference.get().then(
      (value) async {
        if (value.data()!["uid"] != FirebaseAuth.instance.currentUser!.uid) {
          return;
        }
        if (value.data()!["images"] != null) {
          for (String eatch in value.data()!["images"]) {
            await FirebaseStorage.instance.refFromURL(eatch).delete();
          }
        }
        await reference.collection("likes").get().then(
          (value) async {
            for (var eatch in value.docs) {
              await eatch.reference.delete();
            }
          },
        );
        await reference.collection("comments").get().then(
          (value) async {
            for (var eatch in value.docs) {
              await eatch.reference.delete();
            }
          },
        );
        reference.delete();
      },
    );
  }
}
