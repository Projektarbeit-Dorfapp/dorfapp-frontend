import 'package:dorf_app/screens/login/loginDecoration/loginInputDecoration.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class EmailFormField extends StatefulWidget {
  final FocusNode focusRequested;
  final FocusNode focusNext;
  EmailFormField({@required this.focusNext, @required this.focusRequested});
  @override
  _EmailFormFieldState createState() => _EmailFormFieldState();
}

class _EmailFormFieldState extends State<EmailFormField> {
  @override
  Widget build(BuildContext context) {
    final registrationValidator =
        Provider.of<RegistrationValidator>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextFormField(
        style: TextStyle(fontFamily: "Raleway"),
        focusNode: widget.focusRequested,
        keyboardType: TextInputType.emailAddress,
        onChanged: (emailValue) {
          registrationValidator.setEmail(emailValue);
        },
        onFieldSubmitted: (value){
          if(value.isNotEmpty){
            FocusScope.of(context).requestFocus(widget.focusNext);
          }
        },
        validator: (emailValue) {
          if (emailValue.isEmpty)
            return "Es fehlt noch deine E-Mail";
          if (registrationValidator.isEmailInUse)
            return "E-Mail wird bereits genutzt";
          if (registrationValidator.isEmailInvalid)
            return "E-Mail nicht korrekt";
          return null;
        },
        decoration: LoginInputDecoration(
            contentPadding: 5,
            color: Color(0xFF548c58),
            icon: Icons.email,
            labelText: "E-Mail"
        ).decorate(context),
      ),
    );
  }
}
