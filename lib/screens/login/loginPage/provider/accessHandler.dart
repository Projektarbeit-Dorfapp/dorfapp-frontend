import 'package:dorf_app/services/auth/authentification.dart';
import 'package:flutter/material.dart';

class AccessHandler extends ChangeNotifier{

  VoidCallback _logout;
  VoidCallback _login;
  String _uid; ///currently logged in user ID

  String _currentLoginEmail = "";
  String _currentLoginPassword = "";
  bool _isAdmin = false;
  bool _isLoginValidationFailed = false;
  bool _isEmailResetValidationFailed = false;

  get uid => _uid;
  get isLoginValidationFailed => _isLoginValidationFailed;
  get isEmailResetValidationFailed => _isEmailResetValidationFailed;
  get currentEmail => _currentLoginEmail;
  get currentPassword => _currentLoginPassword;

  ///sets user ID, this method is called from logout and login Callback function
  ///inside rootPage. Each login() and logout() call will set user ID to _uid
  setUID(String uid){
    this._uid = uid;
  }

  ///retrieves the stored user ID or loads it from the database if it's empty
  getUID() {
    if ( this._uid == null) {
      this._uid = getUIDFromDatabase();
      final Authentication _auth = Authentication();
      _auth.getCurrentUser().then((test) {
        this._uid = test.uid;
      });
      return this._uid;
    } else {
      return this._uid;
    }
  }

  setIsAdmin(bool isAdmin) {
    this._isAdmin = isAdmin;
  }

  getIsAdmin() {
    return this._isAdmin;
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
  ///Do not call this method outside of rootPage
  initCallbacks(VoidCallback login, VoidCallback logout){
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

  getUIDFromDatabase() {

  }

}