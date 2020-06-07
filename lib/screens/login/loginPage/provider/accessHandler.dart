import 'package:flutter/material.dart';

class AccessHandler extends ChangeNotifier{

  VoidCallback _logout;
  VoidCallback _login;
  String _uid; ///currently logged in user ID

  String _currentLoginEmail = "";
  String _currentLoginPassword = "";
  bool _validationFailed = false;

  get uid => _uid;
  get validationFailed => _validationFailed;
  get loginEmail => _currentLoginEmail;
  get loginPassword => _currentLoginPassword;

  ///Sets callbacks for login and logout operations from the rootPage.
  ///The rootPage decides if loginPage or user dependent homePage should be loaded.
  ///Do not call this method outside of rootPage
  initCallbacks(VoidCallback login, VoidCallback logout){
    _login = login;
    _logout = logout;
  }
  ///Sets validationError to true. This method is used for the login process
  validationError(){
    _validationFailed = true;
  }
  ///sets validationError back to false (default State). This method is used
  ///for the login process
  cancelValidationError(){
    _validationFailed = false;
  }
  setEmail(String email){
    _currentLoginEmail = email;
  }
  setPassword(String password){
    _currentLoginPassword = password;
  }
  ///sets user ID, this method is called from logout and login Callback function
  ///inside rootPage. Each login() and logout() call will set user ID to _uid
  setUID(String uid){
    _uid = uid;
  }
  ///forces logged in user to log out and show loginPage
  logout(){
    _logout.call();
  }
  ///shows homePage, calling this method does not login the user, it will only
  ///show the defined homePage. Make sure, that the user is successfully logged
  ///in when calling this method
  login(){
    _login.call();
  }
  ///Cleanse login info state. Usually called when user successfully
  ///accessed App
  clear(){
    _currentLoginEmail = "";
    _currentLoginPassword = "";
    _validationFailed = false;
  }

}