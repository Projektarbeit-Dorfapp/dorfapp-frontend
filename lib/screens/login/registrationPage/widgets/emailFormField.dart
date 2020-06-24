import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class EmailFormField extends StatefulWidget {
  final FocusNode focusNodeUser;
  final FocusNode focusNodeEmail;
  EmailFormField({@required this.focusNodeEmail, @required this.focusNodeUser});
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
        style: TextStyle(fontFamily: "Raleway"),
        focusNode: widget.focusNodeUser,
        keyboardType: TextInputType.emailAddress,
        onChanged: (emailValue) {
          registrationValidator.setEmail(emailValue);
        },
        onFieldSubmitted: (value){
          if(value.isNotEmpty){
            FocusScope.of(context).requestFocus(widget.focusNodeEmail);
          }
        },
        validator: (emailValue) {
          if (emailValue.isEmpty) {
            return "Es fehlt noch deine E-Mail";
          }
          if (registrationValidator.emailExist) {
            return "Deine E-Mail wird bereits genutzt";
          }
          if (!regex.hasMatch(registrationValidator.currentEmail))
            return "Emailadresse nicht korrekt";
          return null;
        },
        decoration: LoginInputDecoration(
            contentPadding: 5,
            color: Color(0xff95B531),
            icon: Icons.email,
            labelText: "E-Mail"
        ).decorate(context),
      ),
    );
  }
}
