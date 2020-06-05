import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class UserNameFormField extends StatefulWidget {
  final FocusNode focusNode;
  UserNameFormField(this.focusNode);
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
        style: TextStyle(fontFamily: "Raleway"),
        onChanged: (userName){
          registrationValidator.setUserName(userName);
        },
        onFieldSubmitted: (value){
          if(value.isNotEmpty){
              FocusScope.of(context).requestFocus(widget.focusNode);
          }
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
        decoration: LoginInputDecoration(
            contentPadding: 5,
            color: Color(0xff95B531),
            icon: Icons.person,
            labelText: "Dein Benutzername"
        ).decorate(),
      ),
    );
  }
}
