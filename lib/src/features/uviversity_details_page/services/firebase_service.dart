import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  void deletDoc(String path) async {
    await FirebaseFirestore.instance.doc(path).delete();
  }

  Future<void> deletCollection(String path) async {
    QuerySnapshot<Map<String, dynamic>> value =
        await FirebaseFirestore.instance.collection(path).get();
    for (var eatch in value.docs) {
      eatch.reference.delete();
    }
  }

  void deletDocs(List<String> paths) async {
    for (var path in paths) {
      FirebaseFirestore.instance.doc(path).delete();
    }
  }
}
