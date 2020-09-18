import 'package:dorf_app/screens/login/loginPage/widgets/loginEmailFormField.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/passwordResetPage/widgets/resetButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class PasswordResetPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final safeArea = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                child: Container(
                  height:MediaQuery.of(context).size.height * 0.45,
                  child: LoginPicture(),
                ),
              ),
              Container(
                height: (MediaQuery.of(context).size.height - safeArea) * 0.05,
              ),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: <Widget>[
                      LoginEmailFormField(

                      ),
                    ],

                  ),
                ),
              ),
              Container(
                  height: (MediaQuery.of(context).size.height - safeArea) * 0.057,
              ),
              ResetButton(_formKey
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text( "Zurück zum Anmeldebildschirm",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Raleway"
                    ),
                  ),
                ),
              ),
            ],
        ),
      ),
    );
  }
}
