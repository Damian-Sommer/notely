import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notely/view/page/welcome_page.dart';
import '../../../model/registration.dart';
import '../../util/picture_profilepic.dart';

class RegistrationProfilePic extends StatefulWidget {
  const RegistrationProfilePic({super.key});

  @override
  _RegistrationProfilePicState createState() => _RegistrationProfilePicState();
}

class _RegistrationProfilePicState extends State<RegistrationProfilePic> {
  Registration registration = Registration();
  File img = File("");
  PictureProfilePic picturePage = PictureProfilePic();

  _RegistrationProfilePicState() {
    picturePage.image = img;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            picturePage,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    registration.submitForm();
                    if (registration.isValid) {
                      ///await save();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const WelcomePage()),
                          ModalRoute.withName('/'));
                    }
                  },
                  child: const Text("Registrierung"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      registration.chancelForm();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Zurück"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
