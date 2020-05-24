
import 'package:dorf_app/screens/login/login/widgets/emailFormField.dart';
import 'package:dorf_app/screens/login/login/widgets/loginButton.dart';
import 'package:dorf_app/screens/login/login/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/login/widgets/passwordFormField.dart';
import 'package:dorf_app/screens/login/login/widgets/registrationButton.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                LoginPicture(),
                EmailFormField(),
                PasswordFormField(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, top: 10),
                    child: RegistrationButton(

                    ),
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.05,
                ),
                LoginButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
