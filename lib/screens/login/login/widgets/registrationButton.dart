import 'package:flutter/material.dart';

class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/registration');
      },
      child: Text("Neu hier?",
      style: TextStyle(
        color: Colors.blueGrey,
        fontSize: 17
      ),
      ),
    );
  }
}
