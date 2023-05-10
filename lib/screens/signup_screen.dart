
import 'package:flutter/material.dart';

import '../widgets/already_have_an_account.dart';
import '../widgets/rounded_input_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //Some fields to be used in the class.
  //A bool to check and uncheck the Password area.
  late bool _obsecureText = true;

  //Some controllers to control the text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  //A whole widget tree to make th interface of the SignUp Screen
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 70,),
            Container(
              width: size.width - 90,
              height: size.height * 0.4,
              child: Image.asset(
                "assets/signup.png",
                height: size.height * 0.45,
                width: 50,
              ),
            ),
            RoundedInputField(
              hintText: 'Username',
              icon: Icons.person,
              onChanged: (String value) {},
              textEditingController: _usernameController,
            ),
            RoundedInputField(
              hintText: 'Email',
              icon: Icons.person,
              onChanged: (String value) {},
              textEditingController: _emailController,
            ),
            TextFieldContainer(
              child: TextField(
                controller: _passwordController,
                obscureText: _obsecureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  fillColor: Colors.yellow[200],
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
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent[400],
                    //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                 onPressed: (){},// async {
                //   String res = await AuthMethods().signUpUser(
                //       email: _emailController.text,
                //       password: _passwordController.text,
                //       username: _usernameController.text);
                //
                //   if (res == "Success") {
                //     ClearFields();
                //     final snackBar = SnackBar(
                //       content: const Text('User Registered!'),
                //       action: SnackBarAction(
                //         label: 'OK',
                //         onPressed: () {
                //           // Some code to undo the change.
                //         },
                //       ),
                //     );
                //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //   } else {
                //     final snackBar = SnackBar(
                //       content: const Text('Username or Password is Empty!'),
                //       action: SnackBarAction(
                //         label: 'OK',
                //         onPressed: () {
                //           // Some code to undo the change.
                //         },
                //       ),
                //     );
                //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //   }
                // },
                child: Text(
                  "Sign up".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LogInScreen();
                    },
                  ),
                );
              },
              login: false,
            ),
          ],
        ),
      ),
    );
  }

  //A function to clear out the fields for better user experience
  void ClearFields() {
    _emailController.text = "";
    _passwordController.text = "";
    _usernameController.text = "";
  }
}
