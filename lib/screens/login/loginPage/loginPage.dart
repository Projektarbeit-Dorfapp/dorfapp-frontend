
import 'package:dorf_app/screens/login/loginPage/widgets/loginButton.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/registrationTextNavi.dart';
import 'package:dorf_app/screens/login/widgets/customFormField.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback loginCallback;
  LoginPage({@required this.loginCallback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                LoginPicture(),
                CustomFormField(
                  icon: Icons.email,
                  type: FormFieldType.loginEmail,
                  labelText: "Email-Adresse",
                  validation: "",
                ),
                CustomFormField(
                  icon: Icons.lock,
                  type: FormFieldType.username,
                  labelText: "Passwort",
                  validation: "",
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: RegistrationTextNavi(
                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.05,
                ),
                LoginButton(
                  loginCallback: loginCallback,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
