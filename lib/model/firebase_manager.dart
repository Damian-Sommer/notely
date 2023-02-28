import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:notely/model/note_model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:notely/model/user_model.dart';
import '../main.dart';
import 'auth_service.dart';
import 'login_way.dart';

class FirebaseManager {
  static final FirebaseManager _instance = FirebaseManager._internal();
  factory FirebaseManager() => _instance;
  FirebaseManager._internal();

  final FirebaseStorage storage = FirebaseStorage.instance;
  LoginWay loginWay = LoginWay.email;
  String? uid = null;
  List notesIdList = [];
  bool isvalid = true;
  Future<void> signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    loginWay = LoginWay.email;
    isvalid = true;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        uid = currentUser.uid;
      }
    } on FirebaseAuthException catch (e) {
      isvalid = false;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user Found with this Email'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password did not match'),
          ),
        );
      }
    }
  }

  Future<void> signInWithCredential(
      {required OAuthCredential credential}) async {
    print("sign in with credentials");
    loginWay = LoginWay.google;
    await FirebaseAuth.instance.signInWithCredential(credential);
    User? currentUser = FirebaseAuth.instance.currentUser;
    uid = currentUser!.uid;
    String name = currentUser.displayName!;
    String email = currentUser.email!;
    File file = await _fileFromImageUrl(currentUser.photoURL!).then((value) {
      return value;
    });
    String filename = await checkUser().then((value) {
      return value;
    });
    if (await checkUser() != "") {
      deletePhoto(filename: filename);
      deleteUser();
    }
    await saveUser(name, email, uid!, file);
    return;
  }

  Future<void> register(
      {required String email,
      required String password,
      required String name,
      required BuildContext context,
      required File file}) async {
    print("Registration");
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return value;
      });
      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await saveUser(name, email, userCredential.user!.uid, file);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> logout() async {
    print("Logout");
    uid = "";
    if (loginWay == LoginWay.email) {
      print("Logout Email");
      await FirebaseAuth.instance.signOut();
    } else {
      AuthService authService = AuthService();
      await authService.logOut();
    }
    return;
  }

  Future<void> saveUser(String name, email, String uid, File file) async {
    Uuid uuid = const Uuid();
    String filename = uuid.v4();
    String? dir = path.dirname(file.path);
    String newPath = path.join(dir, filename);
    File fileNew = await File(file.path).copy(newPath);
    print("Profilepic: ");
    print('Old Path: ${file.path}');
    print('New Path: ${fileNew.path}');
    print('New Filename: $filename');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name, 'profilepic': filename});
    await uploadPhoto(filePath: fileNew.path, fileName: filename, uid: uid);
    print("User saved");
  }

  Future<void> uploadPhoto(
      {required String filePath,
      required String fileName,
      required String uid}) async {
    print("Upload Photo");
    Reference referenceRoot =
        storage.ref().child("images").child(uid).child(fileName);
    try {
      await referenceRoot.putFile(File(filePath));
      print(await referenceRoot.getDownloadURL());
    } catch (error) {
      print("Couldnt upload Image");
    }
  }

  Future<bool> checkIfUploaded(
      {required String id, required String table}) async {
    await db.collection(table).get().then((event) {
      for (var doc in event.docs) {
        if (doc.id == id) {
          return true;
        }
      }
    });
    return false;
  }

  Future<File> downloadImageByName(
      {required String filename, required String uid}) async {
    print("Start Image download");
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(uid)
        .child(filename);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/$filename.jpeg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    await ref.writeToFile(tempFile);
    print("Finished Image download");
    return tempFile;
  }

  Future<dynamic> downloadDataOfUser() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> fetchDoc = doc.data() as Map<String, dynamic>;
      UserModel user = UserModel();
      user.name = fetchDoc["name"];
      user.email = fetchDoc["email"];
      user.file =
          await downloadImageByName(filename: fetchDoc["profilepic"], uid: uid!)
              .then(
        (value) {
          return value;
        },
      );
      return user;
    } else {
      return null;
    }
  }

  Future<dynamic> getUserByName(String name) async {
    QuerySnapshot doc = await FirebaseFirestore.instance.collection("users").where("name", isGreaterThanOrEqualTo: name)
        .where("name", isLessThan: '${name}z').get();
    if (doc.docs.isNotEmpty) {
      List<UserModel> users = [];

      for(var doc in doc.docs){
        Map<String, dynamic> fetchDoc = doc.data() as Map<String, dynamic>;
        UserModel user = UserModel();
        user.uid = doc.id;
        user.name = fetchDoc["name"];
        user.email = fetchDoc["email"];
        user.file =
        await downloadImageByName(filename: fetchDoc["profilepic"], uid: user.uid)
            .then(
              (value) {
            return value;
          },
        );
        users.add(user);
      }
      return users;
    } else {
      return null;
    }
  }

  Future<dynamic> getUserById(String id) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    if (doc.exists) {
      Map<String, dynamic> fetchDoc = doc.data() as Map<String, dynamic>;
      UserModel user = UserModel();
      user.uid = id;
      user.name = fetchDoc["name"];
      user.email = fetchDoc["email"];
      user.file =
          await downloadImageByName(filename: fetchDoc["profilepic"], uid: id)
          .then(
            (value) {
          return value;
        },
      );
      return user;
    } else {
      return null;
    }
  }

  Future<void> deletePhoto({required String filename}) async {
    Reference referenceRoot =
        storage.ref().child("images").child(uid!).child(filename);
    await referenceRoot.delete().then(
      (value) {
        print("Deleted file");
      },
    );
  }

  Future<String> checkUser() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (doc.exists) {
      Map<String, dynamic> fetchDoc = doc.data() as Map<String, dynamic>;
      return fetchDoc["profilepic"];
    }
    return "";
  }

  void deleteUser() async {
    FirebaseFirestore.instance.collection("users").doc(uid).delete();
  }

  Future<File> _fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(
        path.join(documentDirectory.path, 'ieofmawkjeiwoajfklefmkcl.jpeg'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<void> uploadNote({required NoteModel note}) async {
    note.uid = uid!;

    print("toMap");
    final Map<String, dynamic> map = NoteModel.toMap(note: note);
    String noteId = "";
    await db
        .collection("notes")
        .add(map)
        .then((DocumentReference doc) => {
      print('Note added with ID: ${doc.id}'),
      noteId = doc.id,
    });
  }

  dynamic downloadNotesFromUser() async {
    List notesListTemp = [];
    notesIdList.clear();
    try {
      QuerySnapshot notes =
      await FirebaseFirestore.instance.collection("notes").where("uid", isEqualTo: uid).get();
      if (notes.docs.isEmpty) {

        return null;
      } else {
        for (var elem in notes.docs) {
          notesListTemp.add(elem.data());
          notesIdList.add(elem.id);
        }
        return notesListTemp;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<NoteModel> getNoteById(String id) async {
    DocumentSnapshot doc =
    await FirebaseFirestore.instance.collection("notes").doc(id).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    NoteModel temp = await NoteModel.fromMap(data).then(
          (value) {
        return value;
      },
    );
    return temp;
  }

  Future<void> updateNote(
      {required NoteModel note, required String id}) async {

    final Map<String, dynamic> map = NoteModel.toMap(note: note);
    String rezeptId = "";
    await db
        .collection("notes")
        .doc(id)
        .update(map);
  }

  void deleteNote({required String id}) {
    FirebaseFirestore.instance.collection("notes").doc(id).delete();
  }
}
