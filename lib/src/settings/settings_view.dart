import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/home/home_page.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                ListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: const Text("Theme"),
                  trailing: DropdownButton<ThemeMode>(
                    value: Provider.of<SettingsController>(context).themeMode,
                    onChanged: Provider.of<SettingsController>(context)
                        .updateThemeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('System Theme'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('Light Theme'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('Dark Theme'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomePage.routeName, (route) => false);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(100, 45),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text("LogOut"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
