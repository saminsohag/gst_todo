import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/common/controllers/error_text_controller.dart';
import 'package:gst_todo/src/uviversity_details_page/services/firebase_service.dart';

class EditUniversityAlertDialog extends StatefulWidget {
  const EditUniversityAlertDialog({Key? key, required this.documentSnapshot})
      : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  _EditUniversityAlertDialogState createState() =>
      _EditUniversityAlertDialogState();
}

class _EditUniversityAlertDialogState extends State<EditUniversityAlertDialog> {
  late final TextEditingController _universityName;
  final ErrorTextController _errorTextController = ErrorTextController();
  @override
  void initState() {
    _universityName = TextEditingController(
        text: widget.documentSnapshot.data()["universityName"]);
    super.initState();
  }

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
          onPressed: () async {
            await FirebaseService().deletCollection(
                widget.documentSnapshot.reference.collection("contents").path);
            FirebaseService().deletDoc(widget.documentSnapshot.reference.path);
            Navigator.of(context).pop();
          },
          child: const Text("Delete"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            if (_universityName.text.isEmpty) {
              _errorTextController.setText = "University Name is Empty";
              return;
            }
            _errorTextController.setText = null;
            widget.documentSnapshot.reference.update(
              {
                "universityName": _universityName.text,
              },
            );
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
