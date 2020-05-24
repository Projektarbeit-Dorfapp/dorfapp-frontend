import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class PassWordFormField extends StatefulWidget {
  @override
  _PassWordFormFieldState createState() => _PassWordFormFieldState();
}

class _PassWordFormFieldState extends State<PassWordFormField> {
  @override
  Widget build(BuildContext context) {
    final registrationValidator = Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        onChanged: (password){
          registrationValidator.setPassword(password);
        },
        validator: (password){
          if(password.isEmpty){
            return "Bitte ein Passwort eingeben";
          }
          if(password.length < 6){
            return "Passwort muss mindestens 6 Zeichen lang sein";
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.blueGrey,
          ),
          labelText: "Passwort",
        ),
      ),
    );
  }
}
