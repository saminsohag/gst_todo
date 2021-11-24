import 'package:flutter/material.dart';

class SelectedItemController with ChangeNotifier {
  List<String> _list = [];
  List<String> get list => _list;
  set setList(List<String> value) {
    if (value == _list) return;
    _list = value;
    notifyListeners();
  }

  addItem(String value) {
    if (_list.contains(value)) return;
    _list.add(value);
    notifyListeners();
  }

  remove(String value) {
    _list.remove(value);
    notifyListeners();
  }

  clear() {
    if (_list.isEmpty) return;
    _list.clear();
    notifyListeners();
  }
}
