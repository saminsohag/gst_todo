import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/common/controllers/error_text_controller.dart';

class AddDoneAlertDialog extends StatefulWidget {
  const AddDoneAlertDialog({Key? key}) : super(key: key);

  @override
  _AddDoneAlertDialogState createState() => _AddDoneAlertDialogState();
}

class _AddDoneAlertDialogState extends State<AddDoneAlertDialog> {
  final TextEditingController _universityName = TextEditingController();
  final ErrorTextController _errorTextController = ErrorTextController();
  @override
  void dispose() {
    super.dispose();
    _universityName.dispose();
    _errorTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        children: [
          CupertinoTextField(
            controller: _universityName,
            placeholder: "University Name",
            keyboardType: TextInputType.name,
          ),
          AnimatedBuilder(
            animation: _errorTextController,
            builder: (context, child) {
              if (_errorTextController.text != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorTextController.text!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
      actions: [
        CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancle"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            if (_universityName.text.isEmpty) {
              _errorTextController.setText = "University Name is Empty";
              return;
            }
            _errorTextController.setText = null;
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("university")
                .add({
              "universityName": _universityName.text,
              "done": true,
            });
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
