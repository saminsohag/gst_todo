import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/home/bottom_index_controller.dart';
import 'package:gst_todo/src/home/widgets/alert_dialog_add_done.dart';
import 'package:gst_todo/src/home/widgets/alert_dialog_add_pending.dart';
import 'package:gst_todo/src/news/news_page.dart';
import 'package:gst_todo/src/profile/profile_drawer.dart';
import 'package:gst_todo/src/home/widgets/university_list_view.dart';
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
    return AnimatedBuilder(
      animation: _bottomIndexController,
      builder: (context, snapshot) {
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
          drawer: const ProfileDrawer(),
          body: const [
            UniversityListView(
              key: ValueKey("done"),
              isDone: true,
            ),
            UniversityListView(
              key: ValueKey("pending"),
              isDone: false,
            ),
            NewsPage(),
          ][_bottomIndexController.index],
          bottomNavigationBar: BottomNavigationBar(
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
              BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined),
                label: "News",
              ),
            ],
          ),
          floatingActionButton: (_bottomIndexController.index == 0)
              ? FloatingActionButton.extended(
                  onPressed: () {
                    showCupertinoDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return const AddDoneAlertDialog();
                      },
                    );
                  },
                  label: const Text("Add Done"),
                  icon: const Icon(Icons.add),
                )
              : (_bottomIndexController.index == 1)
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) {
                            return const AddPendingAlertDialog();
                          },
                        );
                      },
                      label: const Text("Add Pending"),
                      icon: const Icon(Icons.add),
                    )
                  : null,
        );
      },
    );
  }
}
