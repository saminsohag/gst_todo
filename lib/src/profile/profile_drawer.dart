import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/profile/edit_profile.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: 200,
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            (!snapshot.hasData)
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    (!snapshot.data!.exists)
                                        ? "Anonymous"
                                        : "${snapshot.data!["name"] ?? "Anonymous"}",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 23,
                                    ),
                                  ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              "${FirebaseAuth.instance.currentUser!.email}",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        right: 10,
                        child: FloatingActionButton.small(
                          elevation: 10,
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          foregroundColor: Theme.of(context).primaryColor,
                          onPressed: (!snapshot.hasData)
                              ? null
                              : () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                      documentSnapshot: snapshot.data!,
                                    ),
                                  ));
                                },
                          child: (!snapshot.hasData)
                              ? const CupertinoActivityIndicator()
                              : const Icon(
                                  Icons.edit,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: const Text("GST ROLL:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["gstRoll"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("GST Application Id:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["gstApplicationId"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("GST Password:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["gstPassword"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("HSC Roll:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["hscRoll"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("HSC passing year:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["hscPassingYear"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("SSC Roll:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["sscRoll"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("SSC passing year:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["sscPassingYear"] ?? "null"}",
                          ),
                  ),
                  ListTile(
                    title: const Text("HSC Registration No:"),
                    trailing: (!snapshot.hasData)
                        ? const CupertinoActivityIndicator()
                        : Text(
                            (!snapshot.data!.exists)
                                ? "null"
                                : "${snapshot.data!["hscRegistrationId"] ?? "null"}",
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
