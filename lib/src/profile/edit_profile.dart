import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/common/controllers/button_state_controller.dart';
import 'package:gst_todo/src/common/widgets/coustome_snack_bar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.documentSnapshot})
      : super(key: key);
  final DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ButtonStateController _saveController = ButtonStateController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _gstRoll = TextEditingController();
  final TextEditingController _gstApplicationId = TextEditingController();
  final TextEditingController _gstPassword = TextEditingController();
  final TextEditingController _hscRoll = TextEditingController();
  final TextEditingController _sscRoll = TextEditingController();
  final TextEditingController _hscPassingYear = TextEditingController();
  final TextEditingController _sscPassingYear = TextEditingController();
  final TextEditingController _hscRegistrationId = TextEditingController();

  @override
  void initState() {
    if (widget.documentSnapshot.exists) {
      _name.text = widget.documentSnapshot["name"] ?? "";
      _gstRoll.text = widget.documentSnapshot["gstRoll"] ?? "";
      _gstApplicationId.text =
          widget.documentSnapshot["gstApplicationId"] ?? "";
      _gstPassword.text = widget.documentSnapshot["gstPassword"] ?? "";
      _hscRoll.text = widget.documentSnapshot["hscRoll"] ?? "";
      _hscPassingYear.text = widget.documentSnapshot["hscPassingYear"] ?? "";
      _sscRoll.text = widget.documentSnapshot["sscRoll"] ?? "";
      _sscPassingYear.text = widget.documentSnapshot["sscPassingYear"] ?? "";
      _hscRegistrationId.text =
          widget.documentSnapshot["hscRegistrationId"] ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _gstRoll.dispose();
    _gstApplicationId.dispose();
    _gstPassword.dispose();
    _hscRoll.dispose();
    _sscRoll.dispose();
    _hscPassingYear.dispose();
    _sscPassingYear.dispose();
    _hscRegistrationId.dispose();
    _saveController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Personal Information",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              label: Text("Name:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "GST Information",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _gstRoll,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("GST Roll:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _gstApplicationId,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("GST Application Id:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _gstPassword,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              label: Text("GST Password:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "HSC & SSC Information",
            style: Theme.of(context).textTheme.headline5,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _hscRoll,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("HSC Roll:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _hscPassingYear,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("HSC Passning Year:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _sscRoll,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("SSC Roll:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _sscPassingYear,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("SSC Passning Year:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _hscRegistrationId,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("Registration Id:"),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancle"),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              AnimatedBuilder(
                animation: _saveController,
                builder: (context, child) {
                  return Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        if (_saveController.isLoading) return;
                        _saveController.setIsLoading = true;
                        if (widget.documentSnapshot.exists) {
                          await widget.documentSnapshot.reference.update(
                            {
                              "name": (_name.text == "") ? null : _name.text,
                              "gstRoll":
                                  (_gstRoll.text == "") ? null : _gstRoll.text,
                              "gstApplicationId": (_gstApplicationId.text == "")
                                  ? null
                                  : _gstApplicationId.text,
                              "gstPassword": (_gstPassword.text == "")
                                  ? null
                                  : _gstPassword.text,
                              "hscRoll":
                                  (_hscRoll.text == "") ? null : _hscRoll.text,
                              "hscPassingYear": (_hscPassingYear.text == "")
                                  ? null
                                  : _hscPassingYear.text,
                              "sscRoll":
                                  (_sscRoll.text == "") ? null : _sscRoll.text,
                              "sscPassingYear": (_sscPassingYear.text == "")
                                  ? null
                                  : _sscPassingYear.text,
                              "hscRegistrationId":
                                  (_hscRegistrationId.text == "")
                                      ? null
                                      : _hscRegistrationId.text,
                            },
                          ).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              CoustomeSnackBar(
                                context,
                                content: "Failed.",
                                isFailed: true,
                              ),
                            );
                          }).whenComplete(() {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              CoustomeSnackBar(
                                context,
                                content: "Saved.",
                              ),
                            );
                          });
                        } else {
                          await widget.documentSnapshot.reference.set(
                            {
                              "name": (_name.text == "") ? null : _name.text,
                              "gstRoll":
                                  (_gstRoll.text == "") ? null : _gstRoll.text,
                              "gstApplicationId": (_gstApplicationId.text == "")
                                  ? null
                                  : _gstApplicationId.text,
                              "gstPassword": (_gstPassword.text == "")
                                  ? null
                                  : _gstPassword.text,
                              "hscRoll":
                                  (_hscRoll.text == "") ? null : _hscRoll.text,
                              "hscPassingYear": (_hscPassingYear.text == "")
                                  ? null
                                  : _hscPassingYear.text,
                              "sscRoll":
                                  (_sscRoll.text == "") ? null : _sscRoll.text,
                              "sscPassingYear": (_sscPassingYear.text == "")
                                  ? null
                                  : _sscPassingYear.text,
                              "hscRegistrationId":
                                  (_hscRegistrationId.text == "")
                                      ? null
                                      : _hscRegistrationId.text,
                            },
                          ).onError((error, stackTrace) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("! Failed."),
                              ),
                            );
                          }).whenComplete(() {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                                CoustomeSnackBar(context, content: "Saved."));
                          });
                        }
                        _saveController.setIsLoading = false;
                      },
                      child: _saveController.isLoading
                          ? const CupertinoActivityIndicator()
                          : const Text("Save"),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
