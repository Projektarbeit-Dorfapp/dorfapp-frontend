import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
enum RealNameType{firstName, lastName}
class RealNameFormField extends StatelessWidget {
  final FocusNode focusNext;
  final FocusNode focusRequested;
  final RealNameType nameType;
  RealNameFormField({@required this.focusNext, @required this.nameType, @required this.focusRequested});

  Widget build(BuildContext context) {
    final registrationValidator = Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        focusNode: focusRequested,
        style: TextStyle(fontFamily: "Raleway"),
        onChanged: (name){
          if(nameType == RealNameType.firstName){
            registrationValidator.setFirstName(name);
          } else {
            registrationValidator.setLastName(name);
          }
        },
        onFieldSubmitted: (value){
          if(value.isNotEmpty){
            FocusScope.of(context).requestFocus(focusNext);
          }
        },
        validator: (name) {
          if(name.isEmpty){
            if(nameType == RealNameType.firstName){
              return "Wie heißt dein Vorname?";
            } else {
              return "Wie heißt dein Nachname?";
            }
          } else return null;
        },
        decoration: LoginInputDecoration(
            contentPadding: 5,
            color: Color(0xFF548c58),
            icon: Icons.person,
            labelText: nameType == RealNameType.firstName ? "Vorname" : "Nachname"
        ).decorate(context),
      ),
    );
  }
}
