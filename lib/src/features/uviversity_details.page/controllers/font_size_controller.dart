import 'package:flutter/material.dart';

class FontSizeController with ChangeNotifier {
  double tempFontSize = 16;
  double _fontSize = 16;
  get fontSize => _fontSize;
  set setFontSize(double value) {
    if (value == _fontSize) return;
    if (value < 16) return;
    if (value > 30) return;
    _fontSize = value;
    notifyListeners();
  }
}
