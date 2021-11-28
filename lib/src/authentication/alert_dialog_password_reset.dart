import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/authentication/password_reset_controller.dart';

class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({Key? key, required this.email}) : super(key: key);
  final TextEditingController email;

  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final PasswordResetController _passwordResetController =
      PasswordResetController();
  @override
  void dispose() {
    super.dispose();
    _passwordResetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _passwordResetController,
        builder: (context, child) {
          return CupertinoAlertDialog(
            title: const Text("Reset Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                if (_passwordResetController.emailNotSended) ...[
                  if (_passwordResetController.isNotSendingEmail) ...[
                    CupertinoTextField(
                      controller: widget.email,
                      placeholder: "Email",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (_passwordResetController.errorMessage != null)
                      Text(
                        _passwordResetController.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                  ],
                  if (_passwordResetController.isSendingEmail) ...[
                    Text("Sending Email to ${widget.email.text}"),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
                if (_passwordResetController.emailSended) ...[
                  Text("Reset email has been sended to ${widget.email.text}"),
                ]
              ],
            ),
            actions: [
              if (_passwordResetController.emailNotSended &&
                  _passwordResetController.isNotSendingEmail)
                CupertinoActionSheetAction(
                  onPressed: () async {
                    _passwordResetController.setErrorMessage = null;
                    if (_passwordResetController.isSendingEmail) return;
                    _passwordResetController.setIsSendingEmail = true;
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: widget.email.text);
                      _passwordResetController.setEmailSended = true;
                    } on FirebaseAuthException catch (e) {
                      _passwordResetController.setErrorMessage = e.message;
                    }
                    _passwordResetController.setIsSendingEmail = false;
                  },
                  child: Text(
                      "${(_passwordResetController.errorMessage != null) ? "Resend" : "Send"} reset email"),
                ),
              if (_passwordResetController.emailSended) ...[
                CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Ok")),
              ],
            ],
          );
        });
  }
}
