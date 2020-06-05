import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class RegistrationButton extends StatelessWidget {
  final _snackBar = SnackBar(
      content: Text("Etwas ist schiefgelaufen, versuche es später erneut"));
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
        color: Color(0xff95B531),
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

    await validator.validateUserName();
    await validator.validateEmail();

    if (_formKey.currentState.validate()) {
      final auth = Provider.of<Authentication>(context, listen: false);
      String uid = "";
      await auth.userSignUp(validator.currentEmail, validator.currentPassword)
          .then((registrationUID) {
            uid = registrationUID;
      }).catchError((e) {
        print(e);
        Scaffold.of(context).showSnackBar(_snackBar);
        return;
      });
      if (uid != "") {
        validator.createUser(uid);
        validator.clear();
        Navigator.pop(context, "success");
      }
    }
  }
}
