import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:gst_todo/src/common/widgets/coustome_snack_bar.dart';
import 'package:gst_todo/src/features/uviversity_details_page/controllers/font_size_controller.dart';
import 'package:gst_todo/src/features/uviversity_details_page/controllers/selected_item_controller.dart';
import 'package:gst_todo/src/features/uviversity_details_page/services/firebase_service.dart';
import 'package:gst_todo/src/features/uviversity_details_page/widgets/message_text_tile.dart';

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
  final SelectedItemController _selectedItemController =
      SelectedItemController();
  final FontSizeController _fontSizeController = FontSizeController();
  @override
  void dispose() {
    super.dispose();
    _text.dispose();
    _scrollController.dispose();
    _selectedItemController.dispose();
    _fontSizeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
            animation: _selectedItemController,
            builder: (context, child) {
              if (_selectedItemController.list.isNotEmpty) {
                return const Text("Select");
              }
              return Text(
                  "${widget.documentSnapshot.data()["universityName"] ?? "Unkhown"}");
            }),
        actions: [
          AnimatedBuilder(
              animation: _selectedItemController,
              builder: (context, child) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: widget.documentSnapshot.reference.snapshots(),
                    initialData: widget.documentSnapshot,
                    builder: (context, snapshot) {
                      if (_selectedItemController.list.isNotEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text(
                                    "${_selectedItemController.list.length}"),
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
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: widget.documentSnapshot.reference
                            .collection("contents")
                            .orderBy("time", descending: true)
                            .snapshots(includeMetadataChanges: true),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text("Empty"),
                              );
                            }
                            return AnimatedBuilder(
                              animation: _selectedItemController,
                              builder: (context, child) {
                                return ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  itemCount: snapshot.data!.docs.length,
                                  reverse: true,
                                  controller: _scrollController,
                                  itemBuilder: (context, index) {
                                    bool _isSelected = _selectedItemController
                                        .list
                                        .contains(snapshot
                                            .data!.docs[index].reference.path);
                                    return MessageTextTile(
                                      isSelected: _isSelected,
                                      documentSnapshot:
                                          snapshot.data!.docs[index],
                                      selectedItemController:
                                          _selectedItemController,
                                      fontSize: _fontSizeController.fontSize,
                                    );
                                  },
                                );
                              },
                            );
                          } else {
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
                animation: _selectedItemController,
                builder: (context, child) {
                  if (_selectedItemController.list.isNotEmpty) {
                    return Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: SizedBox(
                        height: 57,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (_selectedItemController.list.length == 1)
                              IconButton(
                                onPressed: () async {
                                  if (!(_selectedItemController
                                          .listText.length ==
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
                                  String text =
                                      _selectedItemController.listText[0];
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
                                FirebaseService()
                                    .deletDocs(_selectedItemController.list);
                                _selectedItemController.clear();
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
