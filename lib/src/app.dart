import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gst_todo/src/features/authentication/pages/ligin.dart';
import 'package:gst_todo/src/features/home/pages/home.dart';
import 'package:provider/provider.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Provider.of<SettingsController>(context),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 230, 235, 240),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            snackBarTheme: const SnackBarThemeData(
              contentTextStyle: TextStyle(color: Colors.white),
            ),
            cupertinoOverrideTheme: const CupertinoThemeData(
              brightness: Brightness.dark,
              textTheme: CupertinoTextThemeData(),
            ),
          ),
          themeMode: Provider.of<SettingsController>(context).themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return const SettingsView();
                  case HomePage.routeName:
                  default:
                    return const HomePage();
                }
              },
            );
          },
          home: Builder(builder: (context) {
            if (FirebaseAuth.instance.currentUser != null) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          }),
        );
      },
    );
  }
}
