import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login{

  static final Login _singleton = Login._internal();

  factory Login() {
    return _singleton;
  }

  Login._internal();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String _loginValidation = "";
  bool passwordVisible = false;

  void chancelForm() {
    clearFields();
    _loginValidation = "Login beendet";
  }

  String get loginValidation{
    return _loginValidation;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}