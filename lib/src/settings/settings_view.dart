import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/features/home/pages/home.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
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
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            title: const Text("Theme"),
            trailing: DropdownButton<ThemeMode>(
              value: Provider.of<SettingsController>(context).themeMode,
              onChanged:
                  Provider.of<SettingsController>(context).updateThemeMode,
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
          const SizedBox(
            height: 20,
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
            child: const Text("LogOut"),
          ),
        ],
      ),
    );
  }
}
