import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class LoginPasswordFormField extends StatefulWidget {
  final FocusNode focusNode;
  final bool hidePassword;
  LoginPasswordFormField(this.focusNode, this.hidePassword);
  @override
  _LoginPasswordFormFieldState createState() => _LoginPasswordFormFieldState();
}

class _LoginPasswordFormFieldState extends State<LoginPasswordFormField> {
  @override
  Widget build(BuildContext context) {
    final accessHandler = Provider.of<AccessHandler>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(

            focusNode: widget.focusNode,
            style: TextStyle(
              fontFamily: "Raleway",
            ),
            onChanged: (password) {
              accessHandler.setPassword(password);
            },
            validator: (password) {
              if (password.isEmpty) {
                return "Bitte ein Passwort angeben";
              }
              if (accessHandler.isLoginValidationFailed) {
                return "E-Mail oder Passwort ist falsch";
              }
              return null;
            },
            obscureText: widget.hidePassword ? true : false,
            decoration: LoginInputDecoration(
              contentPadding: 40,
                    labelText: "Passwort",
                    icon: Icons.lock,
                    color: Color(0xff95B531))
                .decorate(),
          ),
        ),
      ],
    );
  }
}
