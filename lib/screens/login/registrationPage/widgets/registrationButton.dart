import 'dart:io';

import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:dorf_app/services/authentication_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class RegistrationButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  RegistrationButton(this._formKey);
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
        color: Theme.of(context).buttonColor,
        onPressed: () async{
          await _tryToAddUser(context);
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Registrieren",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
            fontFamily: "Raleway"),
          ),
        ),
      ),
    );
  }
  _tryToAddUser(BuildContext context) async {
    final validator =
      Provider.of<RegistrationValidator>(context, listen: false);

    if( await _isConnected(context) == false)
      return;


    //TODO: UserName Validation is currently not possible due to missing firestore security rule
    //await validator.validateUserName();
    if (_formKey.currentState.validate()) {
      final auth = Provider.of<Authentication>(context, listen: false);
      try {
        Navigator.of(context).push(LoadingOverlay());
        String uid = await auth.userSignUp(
            validator.currentEmail, validator.currentPassword);
        validator.createUser(uid);
        validator.clear();
        Navigator.pop(context); ///disabling loadingOverlay
        Navigator.pop(context, "success"); ///switching back to login screen
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            Navigator.of(context).pop();
            validator.setEmailInUse(true);
            _formKey.currentState.validate();
            validator.setEmailInUse(false);
            break;
          case "ERROR_INVALID_EMAIL":
            Navigator.of(context).pop();
            validator.setEmailValidation(true);
            _formKey.currentState.validate();
            validator.setEmailValidation(false);
            break;
          default:
            Navigator.of(context).pop();
            _showErrorMessage(context);
        }
      }
    }
  }
  Future<bool> _isConnected(BuildContext context) async{
    try{
      await InternetAddress.lookup("example.com");
      return true;
    } on SocketException catch(_){
      Flushbar(
        icon: Icon(Icons.error_outline, color: Color(0xFF548c58)),
        message: "Du hast leider kein Internet",
        duration: Duration(seconds: 3),
      )..show(context);
      return false;
    }
  }
  _showErrorMessage(BuildContext context){
    Flushbar(
      message: "Etwas ist leider schief gelaufen, versuche es später erneuert",
      maxWidth: MediaQuery.of(context).size.width * 0.7,
      icon: Icon(Icons.error_outline, color: Color(0xFF548c58)),
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}
