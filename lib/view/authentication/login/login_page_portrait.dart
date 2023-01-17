import 'package:flutter/material.dart';
import 'package:notely/model/auth_service.dart';

import '../../../controller/user_controller.dart';
import '../../../model/firebase_manager.dart';
import '../../../model/login.dart';
import '../../../model/page.dart';

import '../../page/home_page.dart';
import '../../util/page_container.dart';
import '../registration/registration_page.dart';

class LoginPagePortrait extends StatefulWidget {
  const LoginPagePortrait({Key? key}) : super(key: key);

  @override
  _LoginPagePortraitState createState() => _LoginPagePortraitState();
}

class _LoginPagePortraitState extends State<LoginPagePortrait> {
  UserController userController = UserController();
  late PageContainer containerWidget;
  static List screens = [const HomePage(), const HomePage()];
  List<PageModel> pageList = <PageModel>[];

  _LoginPagePortraitState() {
    pageList.add(PageModel(
        id: 0,
        name: "Home",
        icon: const ImageIcon(AssetImage("assets/icons/home.png")),
        color: const Color(0xffDFDDDD)));
    pageList.add(PageModel(
        id: 1,
        name: "Search",
        icon: const ImageIcon(AssetImage("assets/icons/search.png")),
        color: const Color(0xffDFDDDD)));
  }

  Login login = Login();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              const Text("Email"),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: login.emailController,
                  obscureText: false,
                  decoration: const InputDecoration(
                      labelText: '', hintText: 'Enter your username'),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              const Text("Password"),
              Flexible(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: login.passwordController,
                  obscureText: !login.passwordVisible,
                  //This will obscure text dynamically
                  decoration: InputDecoration(
                    labelText: '',
                    hintText: 'Enter your password',
                    // Here is key idea
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        login.passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          login.passwordVisible = !login.passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  FirebaseManager instance = FirebaseManager();
                  await instance.signIn(
                      email: login.emailController.text,
                      password: login.passwordController.text,
                      context: context);
                  if (instance.isvalid) {
                    await userController.fetchData();
                    setState(() {
                      login.clearFields();
                      if (instance.uid != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PageContainer(
                                pages: pageList, screens: screens),
                          ),
                        );
                      }
                    });
                  }
                },
                child: const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    login.chancelForm();
                  });
                },
                child: const Text("Chancel"),
              ),
            ],
          ),
          Text(login.loginValidation),
          Row(
            children: [
              Flexible(
                child: TextButton(
                  child: const Text("Registration"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                ),
              ),
              Flexible(
                child: TextButton(
                  child: const Text("Google"),
                  onPressed: () async {
                    FirebaseManager firebaseManager = FirebaseManager();
                    await AuthService().signInWithGoogle();
                    if(firebaseManager.uid != null){
                      await userController.fetchData();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PageContainer(
                              pages: pageList, screens: screens),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
