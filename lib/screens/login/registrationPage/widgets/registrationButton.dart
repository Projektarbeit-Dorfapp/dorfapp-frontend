import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class RegistrationButton extends StatelessWidget {
  final snackBar = SnackBar(
      content: Text("Etwas ist schiefgelaufen, versuche es später erneut"));
  final GlobalKey<FormState> formKey;
  RegistrationButton(this.formKey);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      onPressed: () async {
        _tryToAddUser(context);
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          "Registrieren",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }

  _tryToAddUser(BuildContext context) async {
    final validator =
        Provider.of<RegistrationValidator>(context, listen: false);
    await validator.validateUserName();
    await validator.validateEmail();
    if (formKey.currentState.validate()) {
      final auth = Provider.of<Authentication>(context, listen: false);
      String uid = "";
      await auth
          .userSignUp(validator.currentEmail, validator.currentPassword)
          .then((registrationUID) {
        uid = registrationUID;
      }).catchError((e) {
        print(e);
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      });
      if (uid != "") {
        validator.createUser(uid);
        Navigator.pop(context, "sucess");
      }
    }
  }
}
