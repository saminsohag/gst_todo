import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  void dispose() {
    super.dispose();
    _text.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.documentSnapshot.data()["universityName"] ?? "Unkhown"}"),
        actions: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: widget.documentSnapshot.reference.snapshots(),
              initialData: widget.documentSnapshot,
              builder: (context, snapshot) {
                return IconButton(
                    onPressed: () {
                      snapshot.data!.reference
                          .update({"done": !snapshot.data!.data()!["done"]});
                    },
                    icon: Icon((snapshot.data!.data()!["done"])
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_outlined));
              }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).primaryColorLight,
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
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      reverse: true,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
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
                                  color: (snapshot.data!.docs[index].metadata
                                          .hasPendingWrites)
                                      ? Theme.of(context)
                                          .disabledColor
                                          .withOpacity(0.2)
                                      : Theme.of(context).primaryColor,
                                ),
                              )
                            ],
                          ),
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
            ),
          ),
          Container(
            color: Theme.of(context).canvasColor,
            child: Row(
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
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
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
                              FocusScope.of(context).unfocus();
                              _text.clear();
                              _scrollController.animateTo(0,
                                  duration: const Duration(milliseconds: 400),
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
            ),
          ),
        ],
      ),
    );
  }
}
