import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/common/widgets/coustome_snack_bar.dart';
import 'package:gst_todo/src/content/edit_mode_controller.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key? key, required this.documentSnapshot})
      : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final EditModeController _editMode = EditModeController();
  late final TextEditingController _textController;
  @override
  void initState() {
    _textController =
        TextEditingController(text: widget.documentSnapshot.data()["text"]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _editMode.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _editMode,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Content"),
          ),
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: widget.documentSnapshot.reference.snapshots(),
            initialData: widget.documentSnapshot,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minHeight: 120),
                          child: Padding(
                            padding:
                                EdgeInsets.all(_editMode.enabled ? 15 : 25),
                            child: Builder(builder: (context) {
                              if (_editMode.enabled) {
                                return TextField(
                                  controller: _textController,
                                  maxLines: null,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(10),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              } else {
                                return SelectableText(
                                  "${snapshot.data!.data()!["text"]}",
                                  style: const TextStyle(fontSize: 18),
                                );
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: Row(
                      children: [
                        if (_editMode.enabled) ...[
                          Expanded(
                            child: TextButton(
                              key: const ValueKey("cancle button"),
                              onPressed: () {
                                _editMode.setEnabled = _editMode.notEnabled;
                              },
                              child: const Text(
                                "Cancle",
                              ),
                              style: TextButton.styleFrom(
                                primary: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              key: const ValueKey("save button"),
                              onPressed: () {
                                if (_textController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CoustomeSnackBar(
                                      context,
                                      content: "! Text is Empty. Failed",
                                      isFailed: true,
                                    ),
                                  );
                                  return;
                                }
                                snapshot.data!.reference
                                    .update({"text": _textController.text});
                                _editMode.setEnabled = _editMode.notEnabled;
                              },
                              child: const Text("Save"),
                            ),
                          ),
                        ],
                        if (_editMode.notEnabled) ...[
                          Expanded(
                            child: TextButton(
                              key: const ValueKey("edit button"),
                              onPressed: () {
                                _textController.text =
                                    snapshot.data!.data()!["text"] ?? "";
                                _editMode.setEnabled = _editMode.notEnabled;
                              },
                              child: const Text("Edit"),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
