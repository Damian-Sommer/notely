import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'firebase_manager.dart';
class Registration{

  static final Registration _singleton = Registration._internal();

  factory Registration() {
    return _singleton;
  }

  Registration._internal();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File file = File("");

  List<String> _registrationValidation = <String>["","",""];
  bool passwordVisible = false;
  bool isValid = true;
  void submitForm() {
    _registrationValidation = <String>["","",""];
    isValid = true;
    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text)){
      _registrationValidation[0] = "Email muss gültig sein";
      isValid = false;
    }
    if(usernameController.text.length <= 4){
      _registrationValidation[1] = "Benutzername muss über 4 Charaktere lang sein";
      isValid = false;
    }
    if(passwordController.text.length <= 4){
      _registrationValidation[2] = "Passwort muss über 4 Charaktere lang sein";
      isValid = false;
    }
    if(file == File("")){
      _registrationValidation[3] = "Refreshen sie das Profilbild";
      isValid = false;
    }
  }
  void removeAllInputs(){
    isValid = true;
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    file = File("");
    _registrationValidation = <String>["","",""];
  }
  void chancelForm() {
    removeAllInputs();
  }

  List<String> get loginValidation{
    return _registrationValidation;
  }


  Future<void> save({required BuildContext context}) async {
    FirebaseManager firebaseManager = FirebaseManager();
    await firebaseManager.register(
        email: emailController.text,
        password: passwordController.text,
        name: usernameController.text,
        file: file,
        context: context);
  }
}