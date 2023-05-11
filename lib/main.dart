import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/screens/login_screen.dart';
import 'package:group_chat_app/screens/otp_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //#7CF500
//  The color code to be used later on
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat App',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      //Below will be called on the basis of authentication if User is Logged in or Not
      home: LogInScreen(),
    );
  }
}