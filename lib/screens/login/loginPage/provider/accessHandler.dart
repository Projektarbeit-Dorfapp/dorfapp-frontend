import 'package:flutter/material.dart';

class AccessHandler extends ChangeNotifier{

  VoidCallback _logout;
  VoidCallback _login;
  String _userID; ///currently logged in user ID

  String _currentLoginEmail = "";
  String _currentLoginPassword = "";
  bool _isLoginValidationFailed = false;
  bool _isEmailResetValidationFailed = false;

  get userID => _userID;
  get isLoginValidationFailed => _isLoginValidationFailed;
  get isEmailResetValidationFailed => _isEmailResetValidationFailed;
  get currentEmail => _currentLoginEmail;
  get currentPassword => _currentLoginPassword;

  ///sets user ID, this method is called from logout and login Callback function
  ///inside rootPage. Each login() and logout() call will set user ID to _uid
  setUID(String uid){
    _userID = uid;
  }
  ///forces user to log out and show loginPage
  logout(){
    _logout.call();
  }
  ///shows homePage, calling this method does not login the user, it will only
  ///show the defined homePage. Use [Authentication] class and [userSignIn] function
  ///to actually sign in user, then call [login].
  login(){
    _login.call();
  }
  ///Sets callbacks for login and logout operations from the rootPage.
  ///The rootPage decides if loginPage or user dependent homePage should be loaded.
  initCallbacks(VoidCallback login, VoidCallback logout, String userID){
    _userID = userID;
    _login = login;
    _logout = logout;
  }
  setEmail(String email){
    _currentLoginEmail = email.trim();
  }
  setPassword(String password){
    _currentLoginPassword = password.trim();
  }

  ///Cleanse login info state. Usually called when user successfully
  ///accessed App
  clear(){
    _currentLoginEmail = "";
    _currentLoginPassword = "";
    _isLoginValidationFailed = false;
    _isEmailResetValidationFailed = false;
  }
  ///activates or deactivates login validation. the user can only login if
  ///[_isLoginValidationFailed] is false. If true, validation will
  ///fail and the user will see an error message on form fields
  loginValidationError(){
    _isLoginValidationFailed = !_isLoginValidationFailed;
  }
  ///activates or deactivates password reset validation. The user can only
  ///get an email, if [_isEmailResetValidationFailed] is false. If true, validation will
  ///fail and the user will see an error message on Form fields
  emailResetValidationError(){
    _isEmailResetValidationFailed = !_isEmailResetValidationFailed;
  }

}