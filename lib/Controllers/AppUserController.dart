
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ipssi_flutter_firebase/Models/AppUser.dart';

class AppUserController {
  final auth = FirebaseAuth.instance;
  final fireUsers = FirebaseFirestore.instance.collection('Users');
  final storage = FirebaseStorage.instance;

  Future<AppUser> createUser(String lastname, DateTime birthday, String password, String mail, String firstname) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: mail, password: password);
    User userFirebase = result.user!;
    String uid = userFirebase.uid;
    Map<String, dynamic> map = {
      'email': mail,
      'avatar': null,
      'firstname': firstname,
      'lastname': lastname,
      'favorites': []
    };
    addUser(uid, map);
    return getUser(uid);
  }

  Future <AppUser> connectUser(String mail, String password) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: mail, password: password);
    String uid = result.user!.uid;
    return getUser(uid);
  }
  
  Future <AppUser> getUser(String uid) async {
    DocumentSnapshot snapshot = await fireUsers.doc(uid).get();
    return AppUser(snapshot);
  }

  String getId() {
    return auth.currentUser!.uid;
  }
  
  addUser(String uid , Map<String, dynamic> map) {
    fireUsers.doc(uid).set(map);
  }

  updateUser(String uid , Map<String, dynamic> map) {
    fireUsers.doc(uid).update(map);
  }

  deleteUser(String uid){
    fireUsers.doc(uid).delete();
  }
}