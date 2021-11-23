import 'package:flutter/material.dart';

class ErrorTextController with ChangeNotifier {
  String? _text;
  String? get text => _text;
  set setText(String? value) {
    if (value == _text) return;
    _text = value;
    notifyListeners();
  }
}
