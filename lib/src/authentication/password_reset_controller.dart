import 'package:flutter/material.dart';

class PasswordResetController with ChangeNotifier {
  bool _isSendingEmail = false;
  bool _emailSended = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get isSendingEmail => _isSendingEmail;
  bool get emailSended => _emailSended;
  bool get emailNotSended => !_emailSended;
  bool get isNotSendingEmail => !_isSendingEmail;

  set setIsSendingEmail(bool value) {
    if (value == _isSendingEmail) return;
    _isSendingEmail = value;
    notifyListeners();
  }

  set setEmailSended(bool value) {
    if (value == _emailSended) return;
    _emailSended = value;
    notifyListeners();
  }

  set setErrorMessage(String? value) {
    if (value == _errorMessage) return;
    _errorMessage = value;
    notifyListeners();
  }
}
