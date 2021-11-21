import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gst_todo/src/features/authentication/controllers/auth_controller.dart';
import 'package:gst_todo/src/features/home/pages/home.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(
            height: 10,
          ),
          AutofillGroup(
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    label: Text("Email"),
                  ),
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _password,
                  decoration: const InputDecoration(
                    label: Text("Password"),
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
                      return const SizedBox();
                    }
                  },
                ),
                AnimatedBuilder(
                    animation: _authController,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (!_authController.isLoading) {
                                _authController.setIsLoading = true;
                                _authController.setError = null;

                                if (FirebaseAuth.instance.currentUser == null) {
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
                          ElevatedButton(
                            onPressed: () async {
                              if (!_authController.isLoading) {
                                _authController.setIsLoading = true;
                                _authController.setError = null;
                                if (FirebaseAuth.instance.currentUser == null) {
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
                            style: ElevatedButton.styleFrom(
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
    );
  }
}
