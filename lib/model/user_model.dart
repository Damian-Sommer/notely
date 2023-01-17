import 'dart:io';

import 'firebase_manager.dart';

class UserModel{
  String name = "";
  String email = "";
  File file = File("");

  Future<void> logout() async {
    FirebaseManager firebaseManager = FirebaseManager();
    await firebaseManager.logout();
    name = "";
    email = "";
  }
}