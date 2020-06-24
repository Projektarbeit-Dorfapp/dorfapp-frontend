import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class ConfirmedPasswordFormField extends StatefulWidget {
  final FocusNode focusNode;
  final bool hidePassword;
  ConfirmedPasswordFormField({
    @required this.focusNode,
    @required this.hidePassword});
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
        style: TextStyle(fontFamily: "Raleway"),
        focusNode: widget.focusNode,
        validator: (confirmedPassword){
          if(confirmedPassword != registrationValidator.currentPassword){
            return "Dein Passwort muss übereinstimmen";
          }
          return null;
        },
        obscureText: widget.hidePassword ? true : false,
        decoration: LoginInputDecoration(
            contentPadding: 40,
            color: Color(0xff95B531),
            icon: Icons.lock,
            labelText: "Passwort bestätigen"
        ).decorate(context),
        ),
    );
  }
}
