import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/news/news_services.dart';
import 'package:gst_todo/src/news/post_card_controller.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late final PostCardController _postCardController;
  final NewsServices _newsServices = NewsServices();
  @override
  void initState() {
    _postCardController = PostCardController(widget.documentSnapshot)
      ..initializer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _postCardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _postCardController,
        builder: (context, snapshot) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0.3,
                  margin: const EdgeInsets.only(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _postCardController.userName ?? "...",
                              style: const TextStyle(
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              _postCardController.timeStamp ?? "...",
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.documentSnapshot.data()["uid"] ==
                          FirebaseAuth.instance.currentUser!.uid)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: PopupMenuButton(
                            onSelected: (value) {
                              if (value == "delete") {
                                _newsServices.deleteNews(
                                    widget.documentSnapshot.reference);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: "edit",
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.edit_outlined),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Edit"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "delete",
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Icon(Icons.delete),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _postCardController.images?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image.network(
                              _postCardController.images![index],
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: Card(
                                    color: Theme.of(context).canvasColor,
                                    child: const Icon(
                                      Icons.image,
                                      size: 90,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        constraints: const BoxConstraints(minHeight: 10),
                        child: Text(
                          _postCardController.text ?? "...",
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                  "${_postCardController.totalLike ?? ".."} Likes"),
                              style: TextButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.onSurface,
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: const Text("0 Comments"),
                              style: TextButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.onSurface,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    SizedBox(
                      height: 55,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                _postCardController.like();
                              },
                              child: const Icon(Icons.thumb_up),
                              style: TextButton.styleFrom(
                                primary: (_postCardController.isLiked ?? false)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Container(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              child: const Icon(Icons.comment),
                              style: TextButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
