import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notely/controller/update_or_create_controller.dart';

import 'note_users_widget.dart';

class AppBarNote extends StatefulWidget {
  const AppBarNote({super.key});

  @override
  _AppBarNoteState createState() => _AppBarNoteState();
}

class _AppBarNoteState extends State<AppBarNote> {

  UpdateOrCreateController updateOrCreateController = UpdateOrCreateController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: const Color(0x5cd26666),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        if (updateOrCreateController.validate()) {
                          if (updateOrCreateController.updateOrCreate == 0) {
                            updateOrCreateController.update();
                          } else {
                            updateOrCreateController.submit();
                          }
                          updateOrCreateController.reset();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: updateOrCreateController.nameController,
                            focusNode: updateOrCreateController.titleNode,
                            enabled: updateOrCreateController.enabledTitleForm,
                            onFieldSubmitted: (value) {
                              updateOrCreateController.enabledTitleForm = false;
                              updateOrCreateController.titleNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(updateOrCreateController.textNode);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              updateOrCreateController.enabledTitleForm = true;
                              updateOrCreateController.textNode.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(updateOrCreateController.titleNode);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const NoteUsers(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
