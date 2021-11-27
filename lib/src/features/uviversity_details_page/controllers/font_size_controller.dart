import 'package:flutter/material.dart';

class FontSizeController with ChangeNotifier {
  double tempFontSize = 18;
  double _fontSize = 18;
  get fontSize => _fontSize;
  set setFontSize(double value) {
    if (value == _fontSize) return;
    if (value < 18) return;
    if (value > 30) return;
    _fontSize = value;
    notifyListeners();
  }
}
