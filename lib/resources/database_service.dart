import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;

  DatabaseService(
      {this.uid}
      );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  String? giveUserName() {
    return _auth.currentUser!.displayName;
  }

  String? giveUserEmail() {
    return _auth.currentUser!.email;
  }

  void setStatus(String status) async {
    await userCollection
        .doc(_auth.currentUser!.uid)
        .update({
      "status": status,
    });
  }

}
