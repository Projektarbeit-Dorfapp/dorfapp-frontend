
import 'package:dorf_app/constants/page_indexes.dart';
import 'package:dorf_app/screens/home/home.dart';
import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/auth/authentification.dart';
import 'package:dorf_app/services/auth/userService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String _userID = "";
  AuthStatus _currentStatus = AuthStatus.NOT_LOGGED_IN;
  Authentication _auth;
  AccessHandler _accessHandler;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Authentication>(context, listen: false);
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    initiateCallbacks();
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
  initiateCallbacks(){
    _accessHandler.initCallbacks(loginCallback, logoutCallback);
  }
  void loginCallback(){
    _auth.getCurrentUser().then((user) {
      setState(() {
          _userID = user.uid;
          _accessHandler.setUID(_userID);
          _userService.checkIfAdmin(_userID).then((isAdmin) {
            _accessHandler.setIsAdmin(isAdmin);
          });
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
      _accessHandler.setUID(_userID);
      _auth.userSignOut();
    });
  }
  @override
  Widget build(BuildContext context) {
    if(_currentStatus == AuthStatus.WAITING){
      return _getLoadingIndicator();
    } else if(_currentStatus == AuthStatus.NOT_LOGGED_IN){
      return LoginPage();
    } else if (_currentStatus == AuthStatus.LOGGED_IN){
      if(_userID.length > 0 && _userID != null){
        return Home(PageIndexes.NEWSINDEX);
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
