import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notely/controller/note_galery_controller.dart';
import 'package:notely/view/page/notes/update_page.dart';
import 'package:notely/view/util/user_information.dart';

import '../util/note_galery_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteGaleryController noteGaleryController = NoteGaleryController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const UserInformation(),
          TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateOrCreatePage(updateOrCreate: 1),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            child: const Text("Create New"),
          ),
          FutureBuilder<void>(
            future: noteGaleryController.fetchData(),
            builder: (context, AsyncSnapshot<void> snapshot) {
              Widget returnWidget = const Text("Data is Loading");
              if (snapshot.connectionState == ConnectionState.done) {
                returnWidget = Column(
                  children: [
                    NoteGaleryUtil(
                      noteList: noteGaleryController.notesList,
                      noteIdList: noteGaleryController.notesIdList,
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                returnWidget = const Text("Loading Data");
              }
              return returnWidget;
            },
          ),
        ],
      ),
    );
  }
}
