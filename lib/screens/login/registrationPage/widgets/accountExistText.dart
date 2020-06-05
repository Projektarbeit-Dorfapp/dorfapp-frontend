import 'package:flutter/material.dart';

class AccountExistText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,

      child: InkWell(
        onTap: () {
          Navigator.pushReplacementNamed(context, "/rootPage");
        },
        child: Text(
          "Du hast schon ein Account?",
          style: TextStyle(
            fontSize: 18,
              color: Colors.black,
              fontFamily: "Raleway"
          ),),
      ),
    );;
  }
}
