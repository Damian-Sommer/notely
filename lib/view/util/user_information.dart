import 'package:flutter/cupertino.dart';

import '../../controller/user_controller.dart';

class UserInformation extends StatefulWidget{
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation>{

  UserController userController = UserController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Welcome ${userController.userModel.name}"),
        Text("Your Email: ${userController.userModel.email}"),
      ],
    );
  }
}