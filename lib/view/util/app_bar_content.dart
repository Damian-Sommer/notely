import 'package:flutter/material.dart';

import '../../controller/user_controller.dart';
import '../../model/firebase_manager.dart';
import '../page/user_page.dart';

class AppBarContent extends StatefulWidget {
  const AppBarContent({super.key});

  @override
  _AppBarContentState createState() => _AppBarContentState();
}

class _AppBarContentState extends State<AppBarContent> {

  UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Notely',
                  style: TextStyle(
                      color: Color(0xff151414),
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                ),
                profile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profile() {
    FirebaseManager firebaseManager = FirebaseManager();
    if (firebaseManager.uid == "" || firebaseManager.uid == null) {
      return const SizedBox();
    } else {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserPage()),
          );
        },
        child: Image(
          image: FileImage(userController.userModel.file),
          height: 30,
        ),
      );
    }
  }
}
