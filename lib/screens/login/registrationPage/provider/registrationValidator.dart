import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/registrationPage/widgets/villageDropDownFormField.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';

class RegistrationValidator extends ChangeNotifier{
  final userService = UserService();

  bool _userExist = false;
  bool _invalidEmail = false;
  bool _emailInUse = false;
  String _currentUserName = "";
  String _currentEmail = "";
  String _currentPassword = "";
  String _currentFirstName = "";
  String _currentLastName = "";
  ListItem _selectedVillage;

  get isUserNameInUse => _userExist;
  get isEmailInvalid => _invalidEmail;
  get isEmailInUse => _emailInUse;
  get currentEmail => _currentEmail;
  get currentPassword => _currentPassword;
  get currentUserName => _currentUserName;
  get currentFirstName => _currentFirstName;
  get currentLastName => _currentLastName;
  get selectedVillage => _selectedVillage;

  setEmailValidation(bool isEmailInvalid){
    _invalidEmail = isEmailInvalid;
  }

  setEmailInUse(bool isEmailInUse){
    _emailInUse = isEmailInUse;
  }

  setVillage(ListItem item){
    _selectedVillage = item;
    print(item.name);
  }
  ///checkup if user name already exist in database
  validateUserName() async{
    if(_currentUserName != ""){
      _userExist = await userService.validateUser(_currentUserName);
    }
  }
  setLastName(String lastName){
    _currentLastName = lastName.trim();
  }

  setFirstName(String firstName){
    _currentFirstName = firstName.trim();
  }
  setUserName(String userName){
    _currentUserName = userName.trim();
  }
  setEmail(String email){
    _currentEmail = email.trim();
  }
  setPassword(String password){
    _currentPassword = password;
  }
  ///creates User object and saves into [CollectionNames.USER] as a document with rng documentID.
  createUser(String uid) async{
    User user = User(
        municipalReference: _selectedVillage.name,
        firstName: _currentFirstName,
        lastName: _currentLastName,
        email: _currentEmail,
        uid: uid,
        userName: _currentUserName,
        admin: false);
    userService.insertUser(user);

  }
  ///cleanse validator state to default values.
  ///Should normally be called when registration process is complete or canceled
  clear(){
    _userExist = false;
    _invalidEmail = false;
    _emailInUse = false;
    _currentUserName = "";
    _currentEmail = "";
    _currentPassword = "";
    _currentLastName = "";
    _currentFirstName = "";
    _selectedVillage = null;
  }
}