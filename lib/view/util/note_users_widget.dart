import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notely/controller/update_or_create_controller.dart';

import '../../model/firebase_manager.dart';
import '../../model/user_model.dart';

class NoteUsers extends StatefulWidget{
  const NoteUsers({super.key});

  @override
  _NoteUsersState createState() => _NoteUsersState();
}

class _NoteUsersState extends State<NoteUsers>{
  UpdateOrCreateController updateOrCreateController = UpdateOrCreateController();

  @override
  Widget build(BuildContext context) {
    return users();
  }


  Future<UserModel> noteUsers() async {
    return await updateOrCreateController.firebaseManager
        .downloadDataOfUser()
        .then((value) {
      return value;
    });
  }

  Widget users() {
    return GestureDetector(
      onTap: () {
        Widget usersWidget = usersAddedWidget();
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
                            controller: updateOrCreateController.searchUserController,
                            autofocus: true,
                            maxLines: 1,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff262424),
                                ),
                                onPressed: () {
                                  updateOrCreateController.searchUserController.clear();
                                  setState(
                                        () {
                                      usersWidget = usersAddedWidget();
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
                                .getUserByName(
                                updateOrCreateController.searchUserController.text)
                                .then((value) {
                              return value;
                            });
                            if (usersTmp != null) {
                              users = usersTmp;

                              print("h");
                              print(users.length);
                              print(users[0].name);

                              usersWidget = ListView.builder(
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (updateOrCreateController.noteModel.uid !=
                                      users[index].uid) {
                                    return InkWell(
                                      onTap: () {
                                        if (updateOrCreateController.noteModel.uid !=
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
                                            image: FileImage(users[index].file),
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
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: updateOrCreateController.addedUsers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            /// owner
            return Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image: FileImage(updateOrCreateController.noteOwner.file),
                        height: 40,
                      ),
                      Text(
                        updateOrCreateController.noteOwner.name,
                      ),
                    ],
                  ),
                  const Text("Owner"),
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image(
                        image: FileImage(
                            updateOrCreateController.addedUsers[index - 1].file),
                        height: 40,
                      ),
                      Text(
                        updateOrCreateController.addedUsers[index - 1].name,
                      ),
                    ],
                  ),
                  const Text("Contributor"),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}