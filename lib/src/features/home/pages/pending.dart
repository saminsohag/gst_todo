import 'package:flutter/material.dart';

class PendingUniversityPage extends StatefulWidget {
  const PendingUniversityPage({Key? key}) : super(key: key);

  @override
  _PendingUniversityPageState createState() => _PendingUniversityPageState();
}

class _PendingUniversityPageState extends State<PendingUniversityPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return const Card(
          child: ListTile(
            title: Text("North South"),
          ),
        );
      },
    );
  }
}
