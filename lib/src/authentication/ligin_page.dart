import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gst_todo/src/authentication/alert_dialog_password_reset.dart';
import 'package:gst_todo/src/authentication/auth_controller.dart';
import 'package:gst_todo/src/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthController _authController = AuthController();
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _authController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LogIn"),
      ),
      body: NotificationListener(
        onNotification: (OverscrollIndicatorNotification notification) {
          notification.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          reverse: true,
          children: [
            AutofillGroup(
              child: Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: "GST",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      children: [
                        const TextSpan(
                          text: " ",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        TextSpan(
                          text: "Todo",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.035),
                      filled: true,
                    ),
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _password,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      fillColor:
                          Theme.of(context).disabledColor.withOpacity(0.035),
                      filled: true,
                    ),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimatedBuilder(
                    animation: _authController,
                    builder: (context, child) {
                      if (_authController.error != null) {
                        return Text(
                          _authController.error!,
                          style: const TextStyle(color: Colors.red),
                        );
                      } else {
                        return const Text("");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return PasswordResetDialog(
                                email: _email,
                              );
                            });
                      },
                      child: const Text("Forget Password!")),
                  AnimatedBuilder(
                      animation: _authController,
                      builder: (context, snapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (!_authController.isLoading) {
                                  _authController.setIsLoading = true;
                                  _authController.setError = null;

                                  if (FirebaseAuth.instance.currentUser ==
                                      null) {
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _email.text,
                                              password: _password.text);
                                      if (FirebaseAuth.instance.currentUser !=
                                          null) {
                                        TextInput.finishAutofillContext();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                HomePage.routeName,
                                                (route) => false);
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      _authController.setError = e.message;
                                    }
                                  }
                                  _authController.setIsLoading = false;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 45),
                              ),
                              child: (_authController.isLoading)
                                  ? const CupertinoActivityIndicator()
                                  : const Text("LogIn"),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () async {
                                if (!_authController.isLoading) {
                                  _authController.setIsLoading = true;
                                  _authController.setError = null;
                                  if (FirebaseAuth.instance.currentUser ==
                                      null) {
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                              email: _email.text,
                                              password: _password.text);
                                      if (FirebaseAuth.instance.currentUser !=
                                          null) {
                                        TextInput.finishAutofillContext();
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                HomePage.routeName,
                                                (route) => false);
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      _authController.setError = e.message;
                                    }
                                  }
                                  _authController.setIsLoading = false;
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(100, 45),
                              ),
                              child: (_authController.isLoading)
                                  ? const CupertinoActivityIndicator()
                                  : const Text("SignUp"),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
