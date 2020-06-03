import 'package:dorf_app/screens/login/models/user_model.dart';
import 'package:dorf_app/services/auth/userService.dart';
import 'package:flutter/cupertino.dart';

class RegistrationValidator extends ChangeNotifier{
  final userService = UserService();

  bool _userExist = false;
  bool _emailExist = false;
  String _currentUserName = "";
  String _currentEmail = "";
  String _currentPassword = "";

  get userExist => _userExist;
  get emailExist => _emailExist;
  get currentEmail => _currentEmail;
  get currentPassword => _currentPassword;
  get currentUserName => _currentUserName;

  ///checkup if email already exist in database
  validateEmail() async{
    if(_currentEmail != ""){
      _emailExist = await userService.validateEmail(_currentEmail);
    }
  }
  ///checkup if user name already exist in database
  validateUserName() async{
    if(_currentUserName != ""){
      _userExist = await userService.validateUser(_currentUserName);
    }
  }
  setUserName(String userName){
    _currentUserName = userName;
  }
  setEmail(String email){
    _currentEmail = email;
  }
  setPassword(String password){
    _currentPassword = password;
  }
  ///creates User object and saves into user collection as document
  createUser(String uid) async{
    User user = User(
        email: _currentEmail,
        uid: uid,
        userName: _currentUserName);
    userService.insertUser(user);

  }
  ///cleanse validator state to default values.
  ///Should normally be called when registration process is complete or canceled
  clear(){
    _userExist = false;
    _emailExist = false;
     _currentUserName = "";
    _currentEmail = "";
    _currentPassword = "";
  }
}