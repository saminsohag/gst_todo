import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message(this.document, {this.isSelected = false});
  bool isSelected;
  QueryDocumentSnapshot<Map<String, dynamic>> document;
}
