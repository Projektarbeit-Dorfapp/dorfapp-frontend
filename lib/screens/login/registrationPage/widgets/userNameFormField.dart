import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class UserNameFormField extends StatefulWidget {
  @override
  _UserNameFormFieldState createState() => _UserNameFormFieldState();
}

class _UserNameFormFieldState extends State<UserNameFormField> {
  @override
  Widget build(BuildContext context) {
    final registrationValidator = Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        onChanged: (userName){
          registrationValidator.setUserName(userName);
        },
        validator: (userName) {
          if(userName.isEmpty){
            return "Benutzer darf nicht leer sein";
          }
          if(registrationValidator.userExist){
            return "Name ist vergeben";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: Colors.blueGrey,
          ),
          labelText: "Dein Benutzername",
        ),
      ),
    );
  }
}
