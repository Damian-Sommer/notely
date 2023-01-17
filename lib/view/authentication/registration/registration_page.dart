import 'package:flutter/material.dart';
import 'package:notely/view/authentication/registration/registration_page_portrait.dart';

import '../../util/app_bar_content.dart';

class RegistrationPage extends StatefulWidget{

  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarContent(),
      ),
      body: portrait(),//MediaQuery.of(context).orientation == Orientation.portrait ?  portrait() : landscape(),
    );
  }
  Widget portrait(){
    return const RegistrationPagePortrait();
  }
}