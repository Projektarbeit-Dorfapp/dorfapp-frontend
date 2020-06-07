import 'package:dorf_app/screens/login/loginPage/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/registrationPage/provider/registrationValidator.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/confirmedPasswordFormField.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/emailFormField.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/passwordFormField.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/userNameFormField.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/registrationButton.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegistrationValidator(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: Text(
            "Registrieren",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: <Widget>[
                Container(
                  width: 500,
                  height: 100,
                  child: LoginPicture(
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      UserNameFormField(),
                      EmailFormField(),
                      PassWordFormField(),
                      ConfirmedPasswordFormField(),
                    ],
                  ),
                ),
                SizedBox(
                  height: (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).padding.top) *
                      0.05,
                ),
                RegistrationButton(_formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
