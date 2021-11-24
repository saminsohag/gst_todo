import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:gst_todo/src/features/content/pages/content.dart';
import 'package:gst_todo/src/features/uviversity_details.page/controllers/selected_item_controller.dart';
import 'package:gst_todo/src/features/uviversity_details.page/services/firebase_service.dart';

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
  @override
  void dispose() {
    super.dispose();
    _text.dispose();
    _scrollController.dispose();
    _selectedItemController.dispose();
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
                        return TextButton(
                          onPressed: () {},
                          child: Text("${_selectedItemController.list.length}"),
                          style: TextButton.styleFrom(
                              primary:
                                  Theme.of(context).scaffoldBackgroundColor),
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
            child: Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.35),
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
                              bool _isSelected = _selectedItemController.list
                                  .contains(snapshot
                                      .data!.docs[index].reference.path);
                              return Container(
                                  color: (_isSelected)
                                      ? Theme.of(context).primaryColorLight
                                      : Colors.transparent,
                                  child: InkWell(
                                    onTap: (_selectedItemController
                                            .list.isEmpty)
                                        ? () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => ContentPage(
                                                documentSnapshot:
                                                    snapshot.data!.docs[index],
                                              ),
                                            ));
                                          }
                                        : () {
                                            if (_selectedItemController.list
                                                .contains(snapshot
                                                    .data!
                                                    .docs[index]
                                                    .reference
                                                    .path)) {
                                              _selectedItemController.remove(
                                                  snapshot.data!.docs[index]
                                                      .reference.path);
                                            } else {
                                              _selectedItemController.addItem(
                                                  snapshot.data!.docs[index]
                                                      .reference.path);
                                            }
                                          },
                                    onLongPress: () {
                                      if (_selectedItemController.list.contains(
                                          snapshot.data!.docs[index].reference
                                              .path)) {
                                        _selectedItemController.remove(snapshot
                                            .data!.docs[index].reference.path);
                                      } else {
                                        _selectedItemController.addItem(snapshot
                                            .data!.docs[index].reference.path);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.2),
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                                color: (_isSelected)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: Text(
                                                  "${snapshot.data!.docs[index].data()["text"]}",
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50,
                                            child: Icon(
                                              Icons.check_circle_rounded,
                                              color: (snapshot
                                                      .data!
                                                      .docs[index]
                                                      .metadata
                                                      .hasPendingWrites)
                                                  ? Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.2)
                                                  : Theme.of(context)
                                                      .primaryColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          );
                        });
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 3,
                )
              ],
            ),
            child: AnimatedBuilder(
                animation: _selectedItemController,
                builder: (context, child) {
                  if (_selectedItemController.list.isNotEmpty) {
                    return Material(
                      child: SizedBox(
                        height: 57,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                    .withOpacity(0.05),
                                isDense: true,
                                filled: true,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
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
                            color: Theme.of(context).primaryColor,
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
