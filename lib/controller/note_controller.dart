import 'package:notely/model/note_model.dart';

import '../model/firebase_manager.dart';

class NoteController{

  static final NoteController _instance = NoteController._internal();

  factory NoteController() => _instance;

  NoteController._internal();

  String id = "";
  late NoteModel note;

  Future<void> fetchData() async {
    NoteModel tmpNote = await FirebaseManager().getNoteById(id).then(
          (value) {
        return value;
      },
    );
    note = tmpNote;
  }
}