import 'dart:io';

import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  LoginButton(this._formKey);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.7,
      child: RaisedButton(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        color: Color(0xff95B531),
        onPressed: () async {
          await _tryLogin(context);
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Anmelden",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
            fontFamily: "Raleway"),
          ),
        ),
      ),
    );
  }

  ///tries to login user, if error, show error message,
  ///if successful show homePage
  _tryLogin(BuildContext context) async {
    try{
      await InternetAddress.lookup("example.com");
    } on SocketException catch(_){
      _showNoConnectionMessage(context);
      return;
    }
    if (_formKey.currentState.validate()) {
      final accessHandler = Provider.of<AccessHandler>(context, listen: false);
      final auth = Provider.of<Authentication>(context, listen: false);
      Navigator.of(context).push(LoadingOverlay());
      await auth.userSignIn(accessHandler.currentEmail, accessHandler.currentPassword)
          .then((value) {
        Navigator.of(context).pop();
        _showHomePage(accessHandler);

      }).catchError((error) {
        _showErrorWarning(accessHandler);
        Navigator.of(context).pop();
      });
    }
  }
  ///Show defined homePage when userSignIn was successful
  _showHomePage(AccessHandler accessHandler) {
    accessHandler.login();
    accessHandler.clear();
  }
  ///When userSignIn throws an exception, the [accessHandler] validationError will
  ///be set to true and another validate() call will show error messages on
  ///each TextFormField connected to the [_formKey]. After the validation() process
  ///completes the validation error will be set back to false to stop validate() calls to always
  ///be false afterwards
  _showErrorWarning(AccessHandler accessHandler) {
    accessHandler.loginValidationError();
    _formKey.currentState.validate();
    accessHandler.loginValidationError();
  }
  _showNoConnectionMessage(BuildContext context){
    Flushbar(
      icon: Icon(Icons.error_outline, color: Colors.yellow,),
      message: "Du hast leider kein Internet",
      duration: Duration(seconds: 3),
    )..show(context);
  }
}
