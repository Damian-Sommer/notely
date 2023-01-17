import 'package:flutter/material.dart';
import 'package:notely/view/page/welcome_page.dart';

import '../../controller/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserController userController = UserController();
/// please check "I was solving same issue for myself": https://stackoverflow.com/questions/51913561/flutter-drag-down-to-dismiss
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        direction: DismissDirection.vertical,
        key: const Key('key'),
        onDismissed: (_) => Navigator.of(context).pop(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(45.0),
            child: Container(
              color: const Color(0x5cd26666),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Profile',
                          style: TextStyle(
                              color: Color(0xff151414),
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Image(
                    height: 200,
                    width: 200,
                    image: FileImage(userController.userModel.file),
                  ),
                  Text(userController.userModel.name),
                  Text(userController.userModel.email),
                  ElevatedButton(
                    onPressed: () async {
                      await userController.logout();
                      setState(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const WelcomePage()),
                            ModalRoute.withName('/')
                        );
                      });
                    },
                    child: const Text("Abmelden"),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
