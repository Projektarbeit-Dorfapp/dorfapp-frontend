import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  ResetButton(this._formKey);
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
        onPressed: () async{
            if(_formKey.currentState.validate()){
              final auth = Provider.of<Authentication>(context, listen: false);
              final accessHandler = Provider.of<AccessHandler>(context, listen: false);
              Navigator.of(context).push(LoadingOverlay());
              await auth.sendPasswordResetEmail(accessHandler.currentEmail).then((value){
                Navigator.of(context).pop();
                _showSuccessMessage(context);
                accessHandler.clear();
              }).catchError((onError){
                Navigator.of(context).pop();
                _showErrorMessage(accessHandler);
              });
            }
        },
        child: Padding(
          padding: EdgeInsets.all(5),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Passwort zurücksetzen",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
              fontFamily: "Raleway"),
            ),
          ),
        ),
      ),
    );
  }
  _showErrorMessage(AccessHandler accessHandler){
    accessHandler.emailResetValidationError();
    _formKey.currentState.validate();
    accessHandler.emailResetValidationError();
  }
  _showSuccessMessage(BuildContext context){
    Flushbar(
      message: "Wir haben dir eine E-Mail gesendet. Dort kannst du dann ein neues Passwort einrichten",
      maxWidth: MediaQuery.of(context).size.width * 0.7,
      icon: Icon(Icons.error_outline, color: Colors.yellow,),
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.TOP,
    )..show(context);
  }
}
