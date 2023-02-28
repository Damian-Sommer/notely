import 'package:flutter/cupertino.dart';
import 'package:notely/model/note_model.dart';

import '../model/firebase_manager.dart';
import '../model/user_model.dart';

class UpdateOrCreateController {
  static final UpdateOrCreateController _instance = UpdateOrCreateController._internal();

  factory UpdateOrCreateController() => _instance;

  UpdateOrCreateController._internal();

  String id = "";
  double initialExtent = 0.2;
  double minChildSize = 0.2;
  int updateOrCreate = 0;
  double maxChildSize = 0.5;
  bool enabledTitleForm = false;
  bool isExpanded = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController searchUserController = TextEditingController();

  FocusNode titleNode = FocusNode();
  FocusNode textNode = FocusNode();

  NoteModel noteModel = NoteModel();
  List<UserModel> addedUsers = <UserModel>[];
  UserModel noteOwner = UserModel();

  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  FirebaseManager firebaseManager = FirebaseManager();

  List<bool> isCardEnabled = [false, false, false, false, false];
  List<Color> colors = [
    Color(int.parse("0xffbd7f7f")),
    Color(int.parse("0xff529cc4")),
    Color(int.parse("0xff8dd56a")),
    Color(int.parse("0xffac77e1")),
    Color(int.parse("0xfff6f4f4")),
  ];
  List<Color> backgroundColors = [
    const Color(0xeae5e5e5),
    const Color(0xeae5e5e5),
    const Color(0xeae5e5e5),
    const Color(0xeae5e5e5),
    const Color(0xeae5e5e5),
  ];

  bool validate() {
    bool isValid = true;
    if (nameController.text.isEmpty) {
      isValid = false;
    }
    if (infoController.text.isEmpty) {
      isValid = false;
    }
    return isValid;
  }

  Future<void> update() async {
    setColor();
    noteModel.name = nameController.text;
    noteModel.info = infoController.text;
    noteModel.users = addedUsers;
    await noteModel.update(id);
  }

  void reset(){
    noteModel.reset();
    enabledTitleForm = false;
    addedUsers = [];
    isCardEnabled = [false, false, false, false, false];
    nameController.clear();
    infoController.clear();
    searchUserController.clear();
    isExpanded = false;
    id = "";
    titleNode.unfocus();
    textNode.unfocus();
  }

  Future<void> submit() async{
    setColor();
    noteModel.name = nameController.text;
    noteModel.info = infoController.text;
    noteModel.uid = firebaseManager.uid!;
    noteModel.users = addedUsers;
    print("AddedUsersLength: ${addedUsers.length}");
    print("AddedUsersLength: ${noteModel.users.length}");

    await noteModel.save();
  }


  void initNote(){
    noteModel.uid = firebaseManager.uid!;
  }

  void setColor(){
    for(int i = 0; i < isCardEnabled.length; i++){
      if(isCardEnabled[i] == true){
        if(i == 0){
          noteModel.color = "0xffbd7f7f";
        }else if(i == 1){
          noteModel.color = "0xff529cc4";
        }else if(i == 2){
          noteModel.color = "0xff8dd56a";
        }else if(i == 3){
          noteModel.color = "0xffac77e1";
        }else if(i == 4){
          noteModel.color = "0xfff6f4f4";
        }
      }
    }
  }
}
