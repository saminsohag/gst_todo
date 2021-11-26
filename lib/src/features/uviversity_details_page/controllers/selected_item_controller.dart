import 'package:flutter/material.dart';

class SelectedItemController with ChangeNotifier {
  final List<String> _list = [];
  final List<String> _listText = [];
  List<String> get list => _list;
  List<String> get listText => _listText;

  addItem(String value, valueText) {
    if (_list.contains(value)) return;
    _list.add(value);
    _listText.add(valueText);
    notifyListeners();
  }

  remove(String value) {
    if (!_list.contains(value)) return;
    int _index = _list.indexOf(value);
    _list.removeAt(_index);
    _listText.removeAt(_index);
    notifyListeners();
  }

  clear() {
    if (_list.isEmpty) return;
    _list.clear();
    _listText.clear();
    notifyListeners();
  }
}
