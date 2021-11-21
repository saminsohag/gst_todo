import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  set setIsLoading(bool value) {
    if (value == _isLoading) return;
    _isLoading = value;
    notifyListeners();
  }

  String? get error => _error;
  set setError(String? value) {
    if (value == _error) return;
    _error = value;
    notifyListeners();
  }
}
