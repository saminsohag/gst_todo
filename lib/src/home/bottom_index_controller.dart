import 'package:flutter/material.dart';

class BottomIndexController with ChangeNotifier {
  int _index = 0;
  final int _maxIndex = 2;
  int get index => _index;
  set setIndex(int value) {
    if (value == _index) return;
    if (value < 0 || value > _maxIndex) return;
    _index = value;
    notifyListeners();
  }
}
