import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gst_todo/src/features/content/pages/content.dart';
import 'package:gst_todo/src/features/uviversity_details_page/controllers/selected_item_controller.dart';

class MessageTextTile extends StatelessWidget {
  const MessageTextTile({
    Key? key,
    required this.isSelected,
    required this.documentSnapshot,
    required this.selectedItemController,
    this.fontSize = 16,
  }) : super(key: key);
  final bool isSelected;
  final QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot;
  final SelectedItemController selectedItemController;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: (isSelected)
            ? Theme.of(context).primaryColorLight
            : Colors.transparent,
        child: InkWell(
          onTap: (selectedItemController.list.isEmpty)
              ? () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContentPage(
                      documentSnapshot: documentSnapshot,
                    ),
                  ));
                }
              : () {
                  if (selectedItemController.list
                      .contains(documentSnapshot.reference.path)) {
                    selectedItemController
                        .remove(documentSnapshot.reference.path);
                  } else {
                    selectedItemController.addItem(
                      documentSnapshot.reference.path,
                      documentSnapshot.data()["text"],
                    );
                  }
                },
          onLongPress: () {
            if (selectedItemController.list
                .contains(documentSnapshot.reference.path)) {
              selectedItemController.remove(documentSnapshot.reference.path);
            } else {
              selectedItemController.addItem(
                documentSnapshot.reference.path,
                documentSnapshot.data()["text"],
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                        ),
                      ],
                      color: (isSelected)
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        "${documentSnapshot.data()["text"]}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: (documentSnapshot.metadata.hasPendingWrites)
                        ? Theme.of(context).disabledColor.withOpacity(0.2)
                        : Theme.of(context).colorScheme.secondary,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
