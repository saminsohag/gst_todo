import 'package:flutter/material.dart';

class CoustomeSnackBar extends SnackBar {
  CoustomeSnackBar(BuildContext context,
      {Key? key, required Widget content, bool isFailed = false})
      : super(
          key: key,
          backgroundColor: (isFailed)
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
          padding: const EdgeInsets.only(
            left: 20,
            right: 8,
          ),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              content,
              ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: const Text("Ok")),
            ],
          ),
        );
}
