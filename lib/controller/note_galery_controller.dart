import 'package:notely/model/note_model.dart';

import '../model/firebase_manager.dart';

class NoteGaleryController{

  static final NoteGaleryController _instance = NoteGaleryController._internal();

  factory NoteGaleryController() => _instance;

  NoteGaleryController._internal();

  List notesList = <NoteModel>[];
  List notesIdList = [];

  List notesAccessibleList = <NoteModel>[];
  List notesAccessibleIdList = [];

  Future<void> fetchData() async {
    List<NoteModel> noteListTemp = <NoteModel>[];
    List<NoteModel> noteAccessibleListTemp = <NoteModel>[];

    print("Fetching Data");
    FirebaseManager instance = FirebaseManager();

    dynamic notesAccessiblyTMP = await instance.searchForNotesAccessible();
    dynamic notesAccessibleIDTMP = FirebaseManager().notesIDAccessible;
    dynamic notesPersonalTMP = await instance.downloadNotesFromUser();
    dynamic notesPersonalIdTMP = FirebaseManager().notesIdList;
    if (notesPersonalTMP == null) {
      print("Didn't get any Personal Notes");
      notesList = <NoteModel>[];
      notesIdList = [];
    } else {
      noteListTemp = await NoteModel.fromMapList(notesPersonalTMP).then(
            (value) {
          return value;
        },
      );
      notesList = noteListTemp;
      print(notesList.length);
      notesIdList = notesPersonalIdTMP;
      print("Finished Fetching Personal Data");
    }

    if (notesAccessiblyTMP == null) {
      print("Didn't get any accessible Notes");
      notesAccessibleList = <NoteModel>[];
      notesAccessibleIdList = [];
    } else {
      noteAccessibleListTemp = await NoteModel.fromMapList(notesAccessiblyTMP).then(
            (value) {
          return value;
        },
      );
      notesAccessibleList = noteAccessibleListTemp;
      notesAccessibleIdList = notesAccessibleIDTMP;
      print("Finished Fetching Accessible Data");
    }
    return;
  }
}