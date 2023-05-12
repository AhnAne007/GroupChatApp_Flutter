import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User user;
  var verificationId = '';

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String phonenumber}) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        res = "Success";

        await _firestore.collection("users").doc(_auth.currentUser?.uid).set({
          "name": username,
          "email": email,
          "status": "Unavailable",
          "uid": _auth.currentUser?.uid,
          "phonenumber": phonenumber,
          "groups":[],
        });

        user = (await _auth.currentUser)!;
        user?.updateProfile(displayName: username);
        ;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  String? giveUserName() {
    return _auth.currentUser!.displayName;
  }

  String? giveUserEmail() {
    return _auth.currentUser!.email;
  }

  Future<String> loginOut() async {
    String res = "Some Error Occured";
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        "status": "Unavailable",
      });
      await _auth.signOut();

      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> phoneAuthentication(String phoneNumber) async {
    String res = '';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        _auth.signInWithCredential(credential);
        res = "Success";
      },
      codeSent: (verificationId, codeSent) {
        this.verificationId = verificationId;
        res = "Success";
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          print('Wrong Phone Number');
          res = "Wrong Phone Number";
        }
      },
    );
    return res;
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
