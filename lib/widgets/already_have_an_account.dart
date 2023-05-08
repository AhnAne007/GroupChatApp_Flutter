import 'package:flutter/material.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;

  const AlreadyHaveAnAccountCheck({
    Key? key,
    required this.login,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don’t have an Account ? " : "Already have an Account ? ",
          style: const TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: Colors.yellow[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
