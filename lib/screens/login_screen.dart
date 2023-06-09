import 'package:flutter/material.dart';
import 'package:group_chat_app/screens/otp_screen.dart';

import 'package:group_chat_app/screens/signup_screen.dart';
import '../resources/auth_methods.dart';
import '../widgets/already_have_an_account.dart';
import '../widgets/rounded_input_field.dart';
import 'home_page.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late bool _obsecureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SizedBox(
              width: 180,
              height: 100,
              child: Image.asset(
                "assets/chatlogo.png",
                height: size.height * 0.45,
                width: 30,
              ),
            ),
            Container(
              width: size.width - 90,
              height: size.height * 0.3,
              child: Image.asset(
                "assets/login.png",
                height: size.height * 0.45,
                width: 50,
              ),
            ),
            RoundedInputField(
              textEditingController: _emailController,
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (String value) {},
            ),
            RoundedInputField(
              textEditingController: _phoneNumberController,
              hintText: 'Phone#',
              icon: Icons.phone,
              onChanged: (String value) {},
            ),
            TextFieldContainer(
              child: TextField(
                controller: _passwordController,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.green[50],
                  icon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_obsecureText) {
                          _obsecureText = false;
                        } else {
                          _obsecureText = true;
                        }
                      });
                    },
                    child: Icon(
                      _obsecureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  //border: InputBorder.none
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreenAccent[400],
                    //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  String res = await AuthMethods().loginUser(
                      email: _emailController.text,
                      password: _passwordController.text);
                  if (res == "Success") {
                    ClearFields();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomePage();
                        },
                      ),
                    );
                  } else {
                    final snackBar = SnackBar(
                      content: const Text('User Not Found!'),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }, // async {

                // },
                child: Text(
                  "Login".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            AlreadyHaveAnAccountCheck(
              login: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 50,
            ), //For Allignment of Layout
          ],
        ),
      ),
    );
  }

  void ClearFields() {
    _emailController.text = "";
    _passwordController.text = "";
  }
}

//await AuthMethods().phoneAuthentication(_phoneNumberController.text);
