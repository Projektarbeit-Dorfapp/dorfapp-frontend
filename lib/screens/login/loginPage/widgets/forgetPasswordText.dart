import 'package:flutter/material.dart';

class ForgetPasswordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/passwordReset");
      },
      child: Text(
          "Passwort vergessen?",
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: "Raleway"
      ),),
    );
  }
}
