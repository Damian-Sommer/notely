import '../model/firebase_manager.dart';
import '../model/user_model.dart';

class UserController{

  static final UserController _instance = UserController._internal();

  factory UserController() => _instance;

  UserController._internal();

  FirebaseManager firebaseManager = FirebaseManager();
  UserModel userModel = UserModel();

  Future<void> fetchData() async{
    dynamic user = await firebaseManager.downloadDataOfUser().then((value){
      return value;
    });
    userModel= user;
  }

  Future<void> logout() async{
    await userModel.logout();
  }
}