import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/screens/home_page.dart';

import '../screens/login_screen.dart';

class Authenticate extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // now writing code that will check if the user is logged in or not.
  // depending in that the respective screen will open.
  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      //returning HomeScreen
      return HomePage();
    } else {
      //returning LoginScreen
      return LogInScreen();
    }
  }
}