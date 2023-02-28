import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notely/model/firebase_manager.dart';

class AuthService{

  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async{

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    FirebaseManager firebaseManager = FirebaseManager();
    await firebaseManager.signInWithCredential(credential: credential);
    return;
  }

  Future<void> logOut()async{
    print("Google Sign out");
    await googleSignIn.signOut();
  }
}