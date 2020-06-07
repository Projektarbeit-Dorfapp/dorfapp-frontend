import 'dart:ui';

import 'package:dorf_app/screens/login/loginPage/widgets/forgetPasswordText.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginButton.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginEmailFormField.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPasswordFormField.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/loginPicture.dart';
import 'package:dorf_app/screens/login/loginPage/widgets/registrationText.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   FocusNode _focusNode;
   bool _hidePassword = true;
  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _safeArea = MediaQuery.of(context).padding.top;
    double _pictureScreenHeight = MediaQuery.of(context).size.height * 0.5 - _safeArea;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: _safeArea,
            ),
            Container(
              height: _pictureScreenHeight,
              width: MediaQuery.of(context).size.width * 0.7,
              child: LoginPicture(),

            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06),
                child: RegistrationText(),
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            child: LoginEmailFormField(focusNode: _focusNode),
                          ),
                          Positioned(
                            top: 90,
                            child: LoginPasswordFormField(_focusNode, _hidePassword),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 28,
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  _hidePassword = !_hidePassword;
                                });
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: _hidePassword ? Colors.black38 : Color(0xff95B531),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],

            ),
            Container(
              height: (MediaQuery.of(context).size.height - _safeArea) * 0.05,
            ),
            LoginButton(
                _formKey),
            Padding(
                padding: EdgeInsets.only(top: 30),

                child: ForgetPasswordText()
            ),
          ],
        ),
      ),
    );
  }
}
class LoadingOverlay extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 150);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(

          backgroundColor: Colors.lightGreen,),
    );
  }
}