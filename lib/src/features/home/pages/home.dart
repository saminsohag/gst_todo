import 'package:flutter/material.dart';
import 'package:gst_todo/src/features/home/controllers/bottom_index.dart';
import 'package:gst_todo/src/features/home/pages/done.dart';
import 'package:gst_todo/src/features/home/pages/pending.dart';
import 'package:gst_todo/src/settings/settings_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BottomIndexController _bottomIndexController = BottomIndexController();
  @override
  void dispose() {
    super.dispose();
    _bottomIndexController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SettingsView.routeName);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: 200,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Samin Yeasar sohag",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: const [
                ListTile(
                  title: Text("GST ROLL:"),
                  trailing: Text("100203"),
                ),
                ListTile(
                  title: Text("GST Application Id:"),
                  trailing: Text("100203"),
                ),
                ListTile(
                  title: Text("GST Password:"),
                  trailing: Text("100203"),
                ),
                ListTile(
                  title: Text("HSC Roll:"),
                  trailing: Text("146593"),
                ),
                ListTile(
                  title: Text("SSC Roll:"),
                  trailing: Text("239775"),
                ),
                ListTile(
                  title: Text("HSC Registration No:"),
                  trailing: Text("1517740531"),
                ),
              ],
            ),
          ],
        ),
      ),
      body: AnimatedBuilder(
          animation: _bottomIndexController,
          builder: (context, snapshot) {
            return const [
              DoneUniversityListPage(),
              PendingUniversityPage(),
            ][_bottomIndexController.index];
          }),
      bottomNavigationBar: AnimatedBuilder(
        animation: _bottomIndexController,
        builder: (context, child) {
          return BottomNavigationBar(
            currentIndex: _bottomIndexController.index,
            onTap: (value) {
              _bottomIndexController.setIndex = value;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: "Done",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pending),
                label: "Pending",
              ),
            ],
          );
        },
      ),
    );
  }
}
