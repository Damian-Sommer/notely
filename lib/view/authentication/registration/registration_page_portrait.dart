import 'package:flutter/material.dart';

import '../../../model/registration.dart';
import '../../page/welcome_page.dart';
import '../../util/picture_profilepic.dart';

class RegistrationPagePortrait extends StatefulWidget {
  const RegistrationPagePortrait({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPagePortrait> {
  PictureProfilePic picturePage = PictureProfilePic();
  Registration registration = Registration();
  double invalideFontSize = 10.0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                picturePage,
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: registration.usernameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      labelText: 'Username', hintText: 'Enter your username'),
                ),
                Text(
                  registration.loginValidation[1],
                  style: TextStyle(
                    color: const Color(0xffdc2e07),
                    fontSize: invalideFontSize,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: registration.emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: 'Enter your email'),
                  onTap: () {
                    if(registration.usernameController.text != ""){
                      setState(() {

                      });
                    }
                  },
                ),
                Text(
                  registration.loginValidation[0],
                  style: TextStyle(
                    color: const Color(0xffdc2e07),
                    fontSize: invalideFontSize,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: registration.passwordController,
                  obscureText: !registration.passwordVisible,
                  //This will obscure text dynamically
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        registration.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          registration.passwordVisible =
                              !registration.passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  registration.loginValidation[2],
                  style: TextStyle(
                    color: const Color(0xffdc2e07),
                    fontSize: invalideFontSize,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  setState(() {

                  });
                  registration.submitForm();
                  if (registration.isValid) {
                    await PicturePageState.takePicture();
                    await registration.save(context: context);
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
    );
  }
}
