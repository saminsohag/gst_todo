import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gst_todo/src/common/widgets/coustome_snack_bar.dart';
import 'package:gst_todo/src/uviversity_details_page/controllers/font_size_controller.dart';
import 'package:gst_todo/src/uviversity_details_page/controllers/message_list_controller.dart';
import 'package:gst_todo/src/uviversity_details_page/models/message.dart';
import 'package:gst_todo/src/uviversity_details_page/services/firebase_service.dart';
import 'package:gst_todo/src/uviversity_details_page/widgets/message_text_tile.dart';

class UniversityDetailPage extends StatefulWidget {
  const UniversityDetailPage({Key? key, required this.documentSnapshot})
      : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  _UniversityDetailPageState createState() => _UniversityDetailPageState();
}

class _UniversityDetailPageState extends State<UniversityDetailPage> {
  final TextEditingController _text = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FontSizeController _fontSizeController = FontSizeController();
  final MessageListController _messageListController = MessageListController();
  @override
  void initState() {
    _messageListController.initialize(widget.documentSnapshot.reference);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
    _scrollController.dispose();
    _messageListController.dispose();
    _fontSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
            animation: _messageListController,
            builder: (context, child) {
              if (_messageListController.totalSelectation() != 0) {
                return const Text("Select");
              }
              return Text(
                  "${widget.documentSnapshot.data()["universityName"] ?? "Unkhown"}");
            }),
        actions: [
          AnimatedBuilder(
              animation: _messageListController,
              builder: (context, child) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: widget.documentSnapshot.reference.snapshots(),
                    initialData: widget.documentSnapshot,
                    builder: (context, snapshot) {
                      if (_messageListController.totalSelectation() != 0) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: OutlinedButton(
                                onPressed: () {
                                  _messageListController.selectAll();
                                },
                                child: Text(
                                    "${(_messageListController.totalSelectation() == _messageListController.list.length) ? "All" : _messageListController.totalSelectation()}"),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white),
                                  padding: EdgeInsets.zero,
                                  primary: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return IconButton(
                          onPressed: () {
                            snapshot.data!.reference.update(
                                {"done": !snapshot.data!.data()!["done"]});
                          },
                          icon: Icon((snapshot.data!.data()!["done"])
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_outlined));
                    });
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onScaleStart: (value) {
                _fontSizeController.tempFontSize = _fontSizeController.fontSize;
              },
              onScaleUpdate: (value) {
                _fontSizeController.setFontSize =
                    _fontSizeController.tempFontSize * value.scale;
              },
              onScaleEnd: (value) {
                _fontSizeController.tempFontSize = _fontSizeController.fontSize;
              },
              child: AnimatedBuilder(
                  animation: _fontSizeController,
                  builder: (context, child) {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: AnimatedBuilder(
                        animation: _messageListController,
                        builder: (context, snapshot) {
                          if (_messageListController.isLoaded) {
                            if (_messageListController.list.isEmpty) {
                              return const Center(
                                child: Text("Empty"),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.only(bottom: 10),
                              itemCount: _messageListController.list.length,
                              reverse: true,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                return MessageTextTile(
                                  isSelected: _messageListController
                                      .list[index].isSelected,
                                  documentSnapshot: _messageListController
                                      .list[index].document,
                                  messageListController: _messageListController,
                                  index: index,
                                  fontSize: _fontSizeController.fontSize,
                                );
                              },
                            );
                          } else {
                            if (_messageListController.list.isNotEmpty) {
                              _messageListController.clearList();
                            }
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }
                        },
                      ),
                    );
                  }),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                )
              ],
            ),
            child: AnimatedBuilder(
                animation: _messageListController,
                builder: (context, child) {
                  if (_messageListController.totalSelectation() != 0) {
                    return Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SizedBox(
                        height: 57,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_messageListController.totalSelectation() == 1)
                              IconButton(
                                onPressed: () async {
                                  if (!(_messageListController
                                          .totalSelectation() ==
                                      1)) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CoustomeSnackBar(
                                        context,
                                        content: "!Failed",
                                        isFailed: true,
                                      ),
                                    );

                                    return;
                                  }
                                  Message? _tempmsg = _messageListController
                                      .getOnlySelectedDocument();
                                  if (_tempmsg == null) return;
                                  String text =
                                      _tempmsg.document.data()["text"];
                                  await Clipboard.setData(
                                      ClipboardData(text: text));
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CoustomeSnackBar(
                                      context,
                                      content: "Copied",
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              ),
                            IconButton(
                              onPressed: () {
                                FirebaseService().deletDocs(
                                    _messageListController
                                        .getSelectedDocumentPaths());
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 8.0,
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxHeight: 100,
                            ),
                            child: TextField(
                              controller: _text,
                              cursorHeight: 25,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                fillColor: Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.10),
                                isDense: true,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _text,
                        builder: (context, snapshot) {
                          return IconButton(
                            iconSize: 40,
                            splashRadius: 28,
                            onPressed: (_text.text.isEmpty)
                                ? null
                                : () {
                                    if (_text.text.isEmpty) return;
                                    widget.documentSnapshot.reference
                                        .collection("contents")
                                        .add(
                                      {
                                        "text": _text.text,
                                        "time": FieldValue.serverTimestamp(),
                                      },
                                    );
                                    //FocusScope.of(context).unfocus();
                                    _text.clear();
                                    _scrollController.animateTo(0,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeIn);
                                  },
                            icon: const Icon(
                              Icons.send,
                            ),
                            disabledColor: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.1),
                            color: Theme.of(context).colorScheme.secondary,
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
