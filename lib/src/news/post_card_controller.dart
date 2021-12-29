import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostCardController with ChangeNotifier {
  bool _isInitialized = false;
  String? _text;
  String? get text => _text;
  String? _userName;
  String? get userName => _userName;
  String? _timeStamp;
  String? get timeStamp => _timeStamp;
  List<String>? _images;
  List<String>? get images => _images;

  initializer(
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) async {
    if (_isInitialized) return;
    _isInitialized = true;
    _text = documentSnapshot.data()["text"];
    _images = documentSnapshot.data()["images"].isEmpty
        ? []
        : documentSnapshot.data()["images"].cast<String>();
    notifyListeners();

    documentSnapshot.reference
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      _text = event.data()?["text"];
      if (event.data()?["timeStamp"] != null) {
        _timeStamp =
            "${(event.data()!["timeStamp"] as Timestamp).toDate().hour}:${(event.data()!["timeStamp"] as Timestamp).toDate().minute} - ${(event.data()!["timeStamp"] as Timestamp).toDate().day}/${(event.data()!["timeStamp"] as Timestamp).toDate().month}/${(event.data()!["timeStamp"] as Timestamp).toDate().year}";
      }
      notifyListeners();
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(documentSnapshot.data()["uid"])
        .snapshots()
        .listen(
      (event) {
        _userName = event.data()?["name"];
        notifyListeners();
      },
    );
  }
}
