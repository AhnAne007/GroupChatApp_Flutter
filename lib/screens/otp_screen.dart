import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color accentPurpleColor = Color(0xFF6A53A1);
    Color accentDarkGreenColor = Color(0xFF99EC1D);
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "CO\nDE",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              fontSize: 80.0,
            ),
          ),
          Text(
            "Verification".toUpperCase(),
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Enter the verification code sent to your Phone number ",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          OtpTextField(
            numberOfFields: 6,
            filled: true,
            fillColor: Colors.black.withOpacity(0.1),
            borderColor: accentDarkGreenColor,
            focusedBorderColor: accentDarkGreenColor,
            //showFieldAsBox: false,
            //borderWidth: 4.0,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              //handle validation or checks here if necessary
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {},
          ),
          SizedBox(height: 20,),
          SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent[400],
                  textStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              onPressed: () {},
              child: Text("NEXT"),
            ),
          ),
        ],
      ),
    ));
  }
}
