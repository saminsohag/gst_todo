import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddImageController with ChangeNotifier {
  bool _isPosting = false;
  bool get isPosting => _isPosting;
  bool _addImageMode = false;
  bool get addImageMode => _addImageMode;
  final List<String> _imagePathList = [];
  List<String> get imagePathList => _imagePathList;
  bool _uploadingImages = false;
  bool get uploadingImages => _uploadingImages;
  set setIsPosting(bool value) {
    if (_isPosting == value) return;
    _isPosting = value;
    notifyListeners();
  }

  void addImagePath(String path) async {
    if (_uploadingImages) return;
    final ImagePicker _imagePicker = ImagePicker();
    var _image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_image == null) return;
    if (_imagePathList.contains(_image.path)) return;
    _imagePathList.add(_image.path);
    notifyListeners();
  }

  void removeImage(int index) {
    if (_uploadingImages) return;
    if (index > (_imagePathList.length - 1) || index < 0) return;
    _imagePathList.removeAt(index);
    notifyListeners();
  }

  set setImageMode(bool value) {
    if (_uploadingImages) return;
    if (value == _addImageMode) return;
    _addImageMode = value;
    _imagePathList.clear();
    notifyListeners();
  }

  Future<String> _uploadImage(String path, String uniqueId) async {
    var task = await FirebaseStorage.instance
        .ref()
        .child("news")
        .child("images")
        .child("image_${FirebaseAuth.instance.currentUser?.uid}_$uniqueId")
        .putFile(
          File(path),
        );
    return task.ref.getDownloadURL();
  }

  Future<List<String>?> uploadImages(List<String> imagesPath) async {
    if (_uploadingImages) return null;
    _uploadingImages = true;
    notifyListeners();
    final List<String> uids = [];
    for (var eatch in imagesPath) {
      String uid = await _uploadImage(eatch,
          "image_${FirebaseAuth.instance.currentUser?.uid}_${const Uuid().v4()}");
      uids.add(uid);
    }
    _uploadingImages = false;
    _imagePathList.clear();
    notifyListeners();
    return uids;
  }

  postContant(String? text) async {
    if (_isPosting) {
      return;
    }
    _isPosting = true;
    notifyListeners();

    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    await AddImageController().uploadImages(_imagePathList).then(
      (images) {
        if (images == null) return;
        FirebaseFirestore.instance.collection("news").add(
          {
            "uid": FirebaseAuth.instance.currentUser!.uid,
            "text": text,
            "images": images,
            "timeStamp": FieldValue.serverTimestamp(),
          },
        );
      },
    );
    setImageMode = false;
    _isPosting = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _imagePathList.clear();
    super.dispose();
  }
}
