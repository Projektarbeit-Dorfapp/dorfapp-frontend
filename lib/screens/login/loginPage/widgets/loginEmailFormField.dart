import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginEmailFormField extends StatefulWidget {
  final FocusNode focusNode;
  LoginEmailFormField({this.focusNode});
  @override
  _LoginEmailFormFieldState createState() => _LoginEmailFormFieldState();
}

class _LoginEmailFormFieldState extends State<LoginEmailFormField> {
  @override
  Widget build(BuildContext context) {
    final accessHandler = Provider.of<AccessHandler>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            style: TextStyle(
              fontFamily: "Raleway",
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (email){
              accessHandler.setEmail(email);
            },
            onFieldSubmitted: (value){
              if(value.isNotEmpty){
                if(widget.focusNode != null){
                  FocusScope.of(context).requestFocus(widget.focusNode);
                }
              }
            },
            validator: (email){
              if(email.isEmpty){
                return "Bitte E-Mail angeben";
              }
              if(accessHandler.isLoginValidationFailed){
                return "E-Mail oder Passwort inkorrekt";
              }
              if(accessHandler.isEmailResetValidationFailed){
                return "Die angegebene E-Mail ist inkorrekt";
              }
              return null;
            },
            decoration: LoginInputDecoration(
              contentPadding: 5,
              color: Color(0xff95B531),
              icon: Icons.email,
              labelText: "E-Mail"
            ).decorate(),
          ),
        ),
      ],
    );
  }
}
