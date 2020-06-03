import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class EmailFormField extends StatefulWidget {
  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  final regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  @override
  Widget build(BuildContext context) {
    final registrationValidator =
        Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (emailValue) {
          registrationValidator.setEmail(emailValue);
        },
        validator: (emailValue) {
          if (emailValue.isEmpty) {
            return "Bitte eine Emailadresse angeben";
          }
          if (registrationValidator.emailExist) {
            return "Emailadresse wird bereits genutzt";
          }
          if (!regex.hasMatch(registrationValidator.currentEmail))
            return "Emailadresse nicht korrekt";
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.email,
            color: Colors.blueGrey,
          ),
          labelText: "Email-Adresse",
        ),
      ),
    );
  }
}
