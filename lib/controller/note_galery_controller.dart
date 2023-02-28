import 'package:notely/model/note_model.dart';

import '../model/firebase_manager.dart';

class NoteGaleryController{

  static final NoteGaleryController _instance = NoteGaleryController._internal();

  factory NoteGaleryController() => _instance;

  NoteGaleryController._internal();

  List notesList = <NoteModel>[];
  List notesIdList = [];

  Future<void> fetchData() async {
    List<NoteModel> noteListTemp = <NoteModel>[];
    print("Fetching Data");
    FirebaseManager instance = FirebaseManager();
    dynamic rezepteTemp = await instance.downloadNotesFromUser();
    dynamic rezepteIdTemp = FirebaseManager().notesIdList;
    if (rezepteTemp == null) {
      print("Didn't get any Rezepte");
      notesList = <NoteModel>[];
      notesIdList = [];
      return;
    } else {
      noteListTemp = await NoteModel.fromMapList(rezepteTemp).then(
            (value) {
          return value;
        },
      );
      notesList = noteListTemp;
      notesIdList = rezepteIdTemp;
      print("Finished Fetching Data");
    }
    return;
  }
}