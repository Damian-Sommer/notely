import 'package:flutter/material.dart';
import 'package:notely/controller/note_controller.dart';

import '../../controller/note_galery_controller.dart';
import '../../model/note_model.dart';
import '../page/notes/update_page.dart';
import 'note_widget.dart';

class NoteGaleryUtil extends StatefulWidget {
  List noteList = <NoteModel>[];
  List noteIdList = [];

  NoteGaleryUtil(
      {super.key, required this.noteList, required this.noteIdList});

  @override
  _NoteGaleryUtilState createState() => _NoteGaleryUtilState();
}

class _NoteGaleryUtilState extends State<NoteGaleryUtil> {
  @override
  Widget build(BuildContext context) {
    return getRezepte();
  }

  Widget getRezepte() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return ListView.builder(
          physics: const ScrollPhysics(),
          itemCount: widget.noteList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: InkWell(
                      onTap: () {
                        navigateToDetails(widget.noteIdList[index]);
                      },
                      child: NoteWidget(
                          name: widget.noteList[index].name),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: () async{
                          await navigateToDetails(widget.noteIdList[index]);
                        },
                        child: const Icon(Icons.edit),
                      ),
                      const SizedBox(width: 5,),
                      FloatingActionButton(
                        onPressed: () async {
                          await deleteNote(widget.noteIdList[index]);
                        },
                        child: const Icon(Icons.delete_forever),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteNote(String id) async{
    NoteModel noteModel = NoteModel();
    noteModel.delete(id);
    NoteGaleryController noteGaleryController = NoteGaleryController();
    await noteGaleryController.fetchData();
    setState(() {
      widget.noteList = noteGaleryController.notesList;
      widget.noteIdList = noteGaleryController.notesIdList;
    });
  }

  Future<void> navigateToDetails(String id) async {
    NoteController noteController = NoteController();
    noteController.id = id;
    await noteController.fetchData();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      print("Rezept ID: $id");
      return UpdateOrCreatePage(id: id, updateOrCreate: 0,);
    }));
    NoteGaleryController noteGaleryController = NoteGaleryController();
    await noteGaleryController.fetchData();
    widget.noteList = noteGaleryController.notesList;
    widget.noteIdList = noteGaleryController.notesIdList;
    setState(() {});
  }
}
