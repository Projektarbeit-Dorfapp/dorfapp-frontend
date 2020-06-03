import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class ConfirmedPasswordFormField extends StatefulWidget {
  @override
  _ConfirmedPasswordFormFieldState createState() =>
      _ConfirmedPasswordFormFieldState();
}

class _ConfirmedPasswordFormFieldState
    extends State<ConfirmedPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    final registrationValidator = Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        validator: (confirmedPassword){
          if(confirmedPassword != registrationValidator.currentPassword){
            return "Passwort muss übereinstimmen";
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: Colors.blueGrey,
          ),
          labelText: "Passwort bestätigen",
        ),
      ),
    );
  }
}
