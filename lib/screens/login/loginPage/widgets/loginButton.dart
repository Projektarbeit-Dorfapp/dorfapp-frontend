import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  LoginButton(this._formKey);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      color: Colors.blueGrey,
      onPressed: () async {
        await _tryLogin(context);
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          "Anmelden",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  ///tries to login user, if error, show error message,
  ///if successful show homePage
  _tryLogin(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      final accessHandler = Provider.of<AccessHandler>(context, listen: false);
      final auth = Provider.of<Authentication>(context, listen: false);

      auth.userSignIn(accessHandler.loginEmail, accessHandler.loginPassword)
          .then((value) {
        _showHomePage(accessHandler);
      }).catchError((error) {
        _showErrorWarning(accessHandler);
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
    accessHandler.validationError();
    _formKey.currentState.validate();
    accessHandler.cancelValidationError();
  }
}
