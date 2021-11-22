import 'package:flutter/material.dart';

class ButtonStateController with ChangeNotifier {
  bool _isLoading = false;
  get isLoading => _isLoading;
  set setIsLoading(bool value) {
    if (value == _isLoading) return;
    _isLoading = value;
    notifyListeners();
  }
}
