import 'package:dorf_app/screens/login/loginPage/widgets/loginButton.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginEmailFormField.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPasswordFormField.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/registrationTextNavi.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                LoginPicture(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      LoginEmailFormField(),
                      LoginPasswordFormField(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: RegistrationTextNavi(),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.05,
                ),
                LoginButton(_formKey),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: (){
                      //TODO: Change Password process
                    },
                    child: Text("Passwort vergessen?"
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
