import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notely/model/user_model.dart';

import 'firebase_manager.dart';

class NoteModel {
  String uid = "";
  String name = "";
  String info = "";
  String color = "";
  String fontStyle = "";

  List<UserModel> users = <UserModel>[];


  static Map<String, dynamic> toMap({required NoteModel note}) {
    print("toMap");
    List noteUsers = [];
    print("AddedUsersLength: ${note.users.length}");
    for (int i = 1; i <= note.users.length; i++) {

      noteUsers.add({
        "uid":  note.users[i - 1].uid,
      });
      print("User added Note: ${note.users[i - 1].uid}");
    }

    final map = <String, dynamic>{
      "uid": note.uid,
      "name": note.name,
      "info": note.info,
      "color": note.color,
      "fontStyle": note.fontStyle,
      "addedUsers": FieldValue.arrayUnion(noteUsers),
    };
    return map;
  }

  static Future<NoteModel> fromMap(Map<String, dynamic> map) async {
    String uid = map["uid"];
    String name = map["name"];
    String info = map["info"];
    String color = map["color"];
    String fontStyle = map["fontStyle"];

    List<UserModel> addedUsers = [];
    for (var element in List.from(map["addedUsers"])) {
      FirebaseManager firebaseManager = FirebaseManager();
      UserModel userModel = await firebaseManager.getUserById(element["uid"]).then((value){
        return value;
      });
      addedUsers.add(userModel);
    }
    NoteModel noteModel = NoteModel();
    noteModel.info = info;
    noteModel.name = name;
    noteModel.color = color;
    noteModel.fontStyle = fontStyle;
    noteModel.uid = uid;
    noteModel.users = addedUsers;
    return noteModel;
  }

  static Future<List<NoteModel>> fromMapList(List notesList) async {
    List<NoteModel> noteListTemp = <NoteModel>[];
    for (int i = 0; i < notesList.length; i++) {
      String uid = notesList[i]["uid"];
      String name = notesList[i]["name"];
      String info = notesList[i]["info"];
      String color = notesList[i]["color"];
      String fontStyle = notesList[i]["fontStyle"];

      List<UserModel> addedUsers = [];
      for (var element in List.from(notesList[i]["addedUsers"])) {
        FirebaseManager firebaseManager = FirebaseManager();
        UserModel userModel = await firebaseManager.getUserById(element["uid"]).then((value){
          return value;
        });
        addedUsers.add(userModel);
      }
      NoteModel noteModel = NoteModel();
      noteModel.info = info;
      noteModel.name = name;
      noteModel.color = color;
      noteModel.fontStyle = fontStyle;
      noteModel.uid = uid;
      noteModel.users = addedUsers;
      noteListTemp.add(noteModel);
    }
    return noteListTemp;
  }

  Future<void> save() async {
    FirebaseManager firebaseManager = FirebaseManager();
    NoteModel note = NoteModel();
    note.uid = uid;
    note.name = name;
    note.info = info;
    note.color = color;
    note.fontStyle = fontStyle;
    note.users = users;
    await firebaseManager.uploadNote(note: this);
  }

  Future<void> update(String id) async {
    FirebaseManager firebaseManager = FirebaseManager();

    NoteModel note = NoteModel();
    note.uid = uid;
    note.name = name;
    note.info = info;
    note.color = color;
    note.fontStyle = fontStyle;
    note.users = users;
    await firebaseManager.updateNote(note: this, id: id);
  }

  void delete(String id){
    FirebaseManager firebaseManager = FirebaseManager();
    firebaseManager.deleteNote(id: id);
  }

  void reset() {
    color = "";
    info = "";
    name = "";
    users = [];
    uid = "";
    fontStyle = "";
  }
}
