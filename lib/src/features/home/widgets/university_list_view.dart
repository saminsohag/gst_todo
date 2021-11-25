import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/features/home/widgets/edit_university_detail_alert_dialog.dart';
import 'package:gst_todo/src/features/uviversity_details.page/pages/university_pages.dart';

class UniversityListView extends StatefulWidget {
  const UniversityListView({Key? key, this.isDone = false}) : super(key: key);
  final bool isDone;

  @override
  _UniversityListViewState createState() => _UniversityListViewState();
}

class _UniversityListViewState extends State<UniversityListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("university")
            .orderBy("universityName")
            .where(
              "done",
              isEqualTo: widget.isDone,
            )
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("Empty"),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                bottom: 70,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UniversityDetailPage(
                            documentSnapshot: snapshot.data!.docs[index],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return EditUniversityAlertDialog(
                            documentSnapshot: snapshot.data!.docs[index],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          (snapshot.data!.docs[index].metadata.hasPendingWrites)
                              ? const SizedBox(
                                  width: 20,
                                )
                              : Icon(
                                  Icons.check_box,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 20,
                                ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                  "${snapshot.data!.docs[index].data()["universityName"] ?? "Unkonwn"}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }
}
