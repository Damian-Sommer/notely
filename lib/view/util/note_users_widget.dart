import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notely/controller/update_or_create_controller.dart';

import '../../model/firebase_manager.dart';
import '../../model/user_model.dart';

class NoteUsers extends StatefulWidget {
  const NoteUsers({super.key});

  @override
  _NoteUsersState createState() => _NoteUsersState();
}

class _NoteUsersState extends State<NoteUsers> {
  UpdateOrCreateController updateOrCreateController =
      UpdateOrCreateController();
  Map<String, bool> selectedFlag = {};
  bool isSelectionMode = false;
  @override
  Widget build(BuildContext context) {
    return users();
  }

  Future<UserModel> noteUsers() async {
    return await updateOrCreateController.firebaseManager
        .getUserById(updateOrCreateController.noteModel.uid)
        .then((value) {
      return value;
    });
  }

  Widget users() {
    return GestureDetector(
      onTap: () {
        Widget usersWidget = const SizedBox();

        if (updateOrCreateController.addedUsers.isNotEmpty) {
          usersWidget = usersAddedWidget();
        }
        List<UserModel> users = [];
        AlertDialog dialog = AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    const Text("Add User to Note"),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller:
                                updateOrCreateController.searchUserController,
                            autofocus: true,
                            maxLines: 1,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff262424),
                                ),
                                onPressed: () {
                                  updateOrCreateController.searchUserController
                                      .clear();
                                  setState(
                                    () {
                                      usersWidget = Column(
                                        children: [
                                          InkWell(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    helpingWidget(),
                                                    Image(
                                                      image: FileImage(
                                                          updateOrCreateController.noteOwner.file),
                                                      height: 40,
                                                    ),
                                                    Text(updateOrCreateController.noteOwner.name),
                                                  ],
                                                ),
                                                const Text("Owner"),
                                              ],
                                            ),
                                          ),
                                          usersAddedWidget(),
                                        ],
                                      );
                                      ///usersWidget = usersAddedWidget();
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            FirebaseManager firebaseManager = FirebaseManager();

                            dynamic usersTmp = await firebaseManager
                                .getUserByName(updateOrCreateController
                                    .searchUserController.text)
                                .then((value) {
                              return value;
                            });
                            if (usersTmp != null) {
                              users = usersTmp;
                              usersWidget = Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: users.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (updateOrCreateController
                                            .noteModel.uid !=
                                        users[index].uid) {
                                      return InkWell(
                                        onTap: () {
                                          if (updateOrCreateController
                                                  .noteModel.uid !=
                                              users[index].uid) {
                                            print(
                                                "User Added: ${users[index].uid}; ${users[index].name}");
                                            updateOrCreateController.addedUsers
                                                .add(users[index]);
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Image(
                                              image:
                                                  FileImage(users[index].file),
                                              height: 40,
                                            ),
                                            Text(
                                              users[index].name,
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return InkWell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image(
                                                  image: FileImage(
                                                      users[index].file),
                                                  height: 40,
                                                ),
                                                Text(
                                                  users[index].name,
                                                ),
                                              ],
                                            ),
                                            const Text("owner"),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                              setState(() {});
                            } else {
                              usersWidget = const Text(
                                  "No user found with this username");
                              setState(() {});
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                    usersWidget,
                  ],
                ),
              );
            },
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );
      },
      child: FutureBuilder(
        future: noteUsers(),
        builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
          if (snapshot.hasData) {
            updateOrCreateController.noteOwner = snapshot.data!;
            return GestureDetector(
              child: Stack(
                children: [
                  Image(
                    image: FileImage(snapshot.data!.file),
                    height: 30,
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget usersAddedWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: updateOrCreateController.addedUsers.length,
      itemBuilder: (BuildContext context, int index) {
        selectedFlag[updateOrCreateController.addedUsers[index].uid] = false;
        bool isSelected =
            selectedFlag[updateOrCreateController.addedUsers[index].uid]!;
        return InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildSelectIcon(isSelected, index),
                  Text(updateOrCreateController.addedUsers[index].name),
                ],
              ),
              const Text("Contributor"),
            ],
          ),
          onLongPress: () {
            print("select");
            setState(() {
              onLongPress(isSelected, index);
            });
          },
          onTap: (){

            setState(() {
              onTap(isSelected, index);
            });
          },
        );
      },
    );
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[updateOrCreateController.addedUsers[index].uid] =
          !isSelected;
      // If there will be any true in the selectionFlag then
      // selection Mode will be true
      isSelectionMode = true;
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[updateOrCreateController.addedUsers[index].uid] =
            !isSelected;
        isSelectionMode = true;
      });
    }
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    if (isSelectionMode) {
      return SizedBox(
        width: 30,
        height: 30,
        child: Icon(
          isSelected ? Icons.check_box : Icons.check_box_outline_blank,
          color: Theme.of(context).primaryColor,
        ),
      );
    }else{
      return Image(
        image: FileImage(
            updateOrCreateController.addedUsers[index].file),
        height: 40,
      );
    }
  }

  Widget helpingWidget(){
    if(isSelectionMode){
      return const SizedBox(width: 30, height: 30,);
    }
    return const SizedBox();
  }
}
