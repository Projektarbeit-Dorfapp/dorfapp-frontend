
import 'package:dorf_app/constants/page_indexes.dart';
import 'package:dorf_app/screens/home/home.dart';
import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
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
  AlertService _alertService;
  bool _isStreamInitiated = false;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<Authentication>(context, listen: false);
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _alertService = Provider.of<AlertService>(context, listen: false);
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
    _accessHandler.initCallbacks(loginCallback, logoutCallback, _userID);
  }
  void loginCallback(){
    _auth.getCurrentUser().then((user) {
      setState(() {
          _userID = user.uid;
          _accessHandler.setUID(_userID);
          _userService.getUser(_userID).then((user) {
            _accessHandler.setUser(user);
          });
      });
    });
    setState(() {
      _currentStatus = AuthStatus.LOGGED_IN;
    });
  }
  void logoutCallback(){
    _userID = "";
    _accessHandler.setUID(_userID);
    _auth.userSignOut().then((_){
      _alertService.disposeSubscription();
      _isStreamInitiated = false;
      _currentStatus = AuthStatus.NOT_LOGGED_IN;
      setState(() {});
    });

  }
  //Build function is called multiple times which causes multiple alert streams -> caused by this setState mess in loginCallback
  //I will change this in the future if time is not running short
  @override
  Widget build(BuildContext context) {
    if (_currentStatus == AuthStatus.NOT_LOGGED_IN) {
      return LoginPage();
    } else { ///[AuthStatus.LOGGED_IN]
      if(!_isStreamInitiated){
        _isStreamInitiated = true;
        _alertService.initStream(_userService, _accessHandler);
      }
      return Home(PageIndexes.NEWSINDEX, safeAreaHeight: MediaQuery.of(context).padding.top,);
    }
  }
}
