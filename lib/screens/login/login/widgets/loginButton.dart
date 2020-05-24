import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      color: Colors.blueGrey,
      onPressed: (){

      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text("Anmelden",
        style: TextStyle(
          color: Colors.white,
          fontSize: 30
        ),
        ),
      ),
    );
  }
}
