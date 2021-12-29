import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/news/add_image_controller.dart';
import 'package:gst_todo/src/news/post_card.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _text = TextEditingController();
  final AddImageController _addImageController = AddImageController();

  @override
  void dispose() {
    super.dispose();
    _text.dispose();
    _addImageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("news")
                  .orderBy("timeStamp", descending: true)
                  .snapshots(includeMetadataChanges: true),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("Empty"),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                        key: ValueKey(snapshot.data!.docs[index].id),
                        documentSnapshot: snapshot.data!.docs[index],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              }),
        ),
        AnimatedBuilder(
            animation: _addImageController,
            builder: (context, snapshot) {
              return Material(
                color: Theme.of(context).canvasColor,
                shadowColor: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_addImageController.addImageMode)
                      SizedBox(
                        height: 100,
                        child: ListView(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 8,
                            right: 8,
                            bottom: 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  _addImageController.imagePathList.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 15,
                                      ),
                                      child: Image.file(
                                        File(_addImageController
                                            .imagePathList[index]),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          _addImageController.uploadingImages,
                                      child: Positioned(
                                        top: 0,
                                        right: 15,
                                        left: 0,
                                        bottom: 0,
                                        child: Container(
                                          color: Colors.black.withOpacity(0.3),
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          )),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          !_addImageController.uploadingImages,
                                      child: Positioned(
                                        top: -6,
                                        right: 5,
                                        child: SizedBox(
                                          height: 26,
                                          width: 26,
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              _addImageController
                                                  .removeImage(index);
                                            },
                                            backgroundColor:
                                                Theme.of(context).errorColor,
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            child: const Icon(
                                                Icons.highlight_remove),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: OutlinedButton(
                                onPressed: () {
                                  _addImageController.addImagePath("");
                                },
                                child:
                                    const Icon(Icons.add_circle_outline_sharp),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          color: (_addImageController.addImageMode)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).disabledColor,
                          onPressed: () {
                            _addImageController.setImageMode =
                                !_addImageController.addImageMode;
                          },
                          icon: const Icon(Icons.photo_library_outlined),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              left: 4.0,
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
                              onPressed: (_text.text.isEmpty &&
                                      _addImageController.imagePathList.isEmpty)
                                  ? null
                                  : () async {
                                      if (_addImageController.uploadingImages) {
                                        return;
                                      }

                                      if (FirebaseAuth.instance.currentUser ==
                                          null) {
                                        return;
                                      }
                                      await AddImageController()
                                          .uploadImages(
                                              _addImageController.imagePathList)
                                          .then(
                                        (images) {
                                          if (images == null) return;
                                          FirebaseFirestore.instance
                                              .collection("news")
                                              .add(
                                            {
                                              "uid": FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              "text": _text.text,
                                              "images": images,
                                              "timeStamp":
                                                  FieldValue.serverTimestamp(),
                                            },
                                          );
                                        },
                                      );
                                      _text.clear();
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
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
