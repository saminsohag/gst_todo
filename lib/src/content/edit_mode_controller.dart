import 'package:flutter/material.dart';

class EditModeController with ChangeNotifier {
  bool _enabled = false;
  bool get enabled => _enabled;
  bool get notEnabled => !_enabled;
  set setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }
}
