import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notely/model/firebase_manager.dart';

class AuthService{
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
}