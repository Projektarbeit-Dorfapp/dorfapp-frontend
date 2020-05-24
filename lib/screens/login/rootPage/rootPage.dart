
import 'package:dorf_app/screens/home/home.dart';
import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String _userID = "";
  AuthStatus _currentStatus = AuthStatus.NOT_LOGGED_IN;
  Authentication _auth;
  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Authentication>(context, listen: false);
    _auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null){
          _userID = user?.uid;
        }
        _currentStatus = user?.uid == null
            ? AuthStatus.NOT_LOGGED_IN
            : AuthStatus.LOGGED_IN;
      });
    });
  }
  void loginCallback(){
    _auth.getCurrentUser().then((user) {
      setState(() {
          _userID = user.uid;
      });
    });
    setState(() {
      _currentStatus = AuthStatus.LOGGED_IN;
    });
  }
  void logoutCallback() {
    setState(() {
      _currentStatus = AuthStatus.NOT_LOGGED_IN;
      _userID = "";
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_currentStatus == AuthStatus.WAITING){
      return _getLoadingIndicator();
    } else if(_currentStatus == AuthStatus.NOT_LOGGED_IN){
      return LoginPage(
        loginCallback: loginCallback
      );
    } else if (_currentStatus == AuthStatus.LOGGED_IN){
      if(_userID.length > 0 && _userID != null){
        return Home();
      } else {
        return _getLoadingIndicator();
      }
    } else return _getLoadingIndicator();
  }

  Widget _getLoadingIndicator(){
    return Container(
      alignment: Alignment.bottomCenter,
      child: CircularProgressIndicator(),
    );
  }
}
