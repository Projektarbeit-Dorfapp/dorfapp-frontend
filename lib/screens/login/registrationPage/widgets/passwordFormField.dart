import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class PassWordFormField extends StatefulWidget {
  final FocusNode focusNodeEmail;
  final FocusNode focusNodePassword;
  final bool hidePassword;
  PassWordFormField({
  @required this.focusNodeEmail,
  @required this.focusNodePassword,
  @required this.hidePassword});
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
        style: TextStyle(fontFamily: "Raleway"),
        focusNode: widget.focusNodeEmail,
        onChanged: (password){
          registrationValidator.setPassword(password);
        },
        onFieldSubmitted: (value){
          if(value.isNotEmpty){
            FocusScope.of(context).requestFocus(widget.focusNodePassword);
          }
        },
        validator: (password){
          if(password.isEmpty){
            return "Es fehlt noch ein Passwort";
          }
          if(password.length < 6){
            return "Passwort muss mindestens 6 Zeichen lang sein";
          }
          return null;
        },
        obscureText: widget.hidePassword ? true : false,
        decoration: LoginInputDecoration(
            contentPadding: 40,
            color: Color(0xFF548c58),
            icon: Icons.lock,
            labelText: "Passwort"
        ).decorate(),
      ),
    );
  }
}
