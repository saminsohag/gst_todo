import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/uviversity_details_page/models/message.dart';

class MessageListController with ChangeNotifier {
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  final List<Message> _list = [];
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> sub;
  initialize(DocumentReference<Map<String, dynamic>> documentReference) async {
    sub = documentReference
        .collection("contents")
        .orderBy("time", descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      _isLoaded = true;
      fromQuerySnapshot(event.docs);
    });
  }

  List<Message> get list => _list;
  fromQuerySnapshot(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documentSnapshot) {
    _list.clear();
    for (var eatch in documentSnapshot) {
      _list.add(Message(eatch));
    }
    notifyListeners();
  }

  selectItem(int index) {
    _list[index].isSelected = !_list[index].isSelected;
    notifyListeners();
  }

  clearList({bool withNotify = true}) {
    _list.clear();
    if (withNotify) notifyListeners();
  }

  int totalSelectation() {
    int value = 0;

    for (var eatch in _list) {
      if (eatch.isSelected) value++;
    }
    return value;
  }

  Message? getOnlySelectedDocument() {
    for (var eatch in _list) {
      if (eatch.isSelected) {
        return eatch;
      }
    }
  }

  List<String> getSelectedDocumentPaths() {
    List<String> _paths = [];
    for (var eatch in _list) {
      if (eatch.isSelected) {
        _paths.add(eatch.document.reference.path);
      }
    }
    return _paths;
  }

  selectAll() {
    if (totalSelectation() == _list.length) {
      for (var eatch in _list) {
        eatch.isSelected = false;
      }
    } else {
      for (var eatch in _list) {
        eatch.isSelected = true;
      }
    }
    notifyListeners();
  }

  unSelectAll() {
    for (var eatch in _list) {
      eatch.isSelected = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
}
