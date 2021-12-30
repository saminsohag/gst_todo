import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostCardController with ChangeNotifier {
  PostCardController(this._documentSnapshot);
  final QueryDocumentSnapshot<Map<String, dynamic>> _documentSnapshot;
  bool _isInitialized = false;
  String? _text;
  String? get text => _text;
  String? _userName;
  String? get userName => _userName;
  String? _timeStamp;
  String? get timeStamp => _timeStamp;
  List<String>? _images;
  List<String>? get images => _images;
  int? _totalLike;
  int? get totalLike => _totalLike;
  int? _totalComment;
  int? get totalComment => _totalComment;

  bool? _isLiked;
  bool? get isLiked => _isLiked;

  initializer() async {
    if (_isInitialized) return;
    _isInitialized = true;
    _text = _documentSnapshot.data()["text"];
    _images = _documentSnapshot.data()["images"].isEmpty
        ? []
        : _documentSnapshot.data()["images"].cast<String>();
    notifyListeners();

    _documentSnapshot.reference.collection("likes").snapshots().listen(
      (event) {
        _totalLike = event.docs.length;
        _isLiked = false;
        for (var eatch in event.docs) {
          if (eatch.id == FirebaseAuth.instance.currentUser!.uid) {
            _isLiked = true;
          }
        }
        notifyListeners();
      },
    );
    _documentSnapshot.reference
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
        .doc(_documentSnapshot.data()["uid"])
        .snapshots()
        .listen(
      (event) {
        _userName = event.data()?["name"];
        notifyListeners();
      },
    );
  }

  void like() {
    bool tempIsLiked = false;
    _documentSnapshot.reference.collection("likes").get().then((value) {
      for (var eatch in value.docs) {
        if (eatch.id == FirebaseAuth.instance.currentUser!.uid) {
          tempIsLiked = true;
        }
      }
      if (tempIsLiked) {
        _documentSnapshot.reference
            .collection("likes")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .delete();
      } else {
        _documentSnapshot.reference
            .collection("likes")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({"lavel": 1});
      }
    });
  }
}
