
import 'dart:io';

import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/profile/profile.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {

  UserService _userService;
  Authentication _auth;
  User _currentUser;
  bool _isDataLoaded = false;

  File _image;
  String _uploadedFileURL;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _ageController;
  TextEditingController _houseNumberController;
  TextEditingController _streetController;
  TextEditingController _zipController;
  final _amountValidator = RegExInputFormatter.withRegex('^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');



  @override
  void initState() {
    _userService = Provider.of<UserService>(context, listen: false);
    _auth = Provider.of<Authentication>(context, listen: false);
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profil editieren',),
      ),
      body: _isDataLoaded ? Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              height: 150,
              width: 150,
              child: new Padding(
                child: InkWell(
                    child: new CircleAvatar(
                      radius: 80,
                      backgroundImage:  _currentUser.imagePath == "" ? AssetImage(
                          "assets/avatar.png") : NetworkImage(_currentUser.imagePath)
                    ),
                    onTap: () {
                      _pickImage();
                    }
                ),
                padding: EdgeInsets.only(top: 10, left: 10),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Vorname: "
                        ),
                      ),
                      TextFormField(
                        controller: _firstNameController,
                      ),
                      Container(
                        child: Text(
                            "Nachname: "
                        ),
                      ),
                      TextFormField(
                        controller: _lastNameController,
                      ),
                      Container(
                        child: Text(
                            "Alter: "
                        ),
                      ),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [_amountValidator],
                        onChanged: (value) {
                          setState(() {
                            _currentUser.age = int.parse(value);
                          });
                        },
                      ),
                      Container(
                        child: Text(
                            "Straße: "
                        ),
                      ),
                      TextFormField(
                        controller: _streetController,
                      ),
                      Container(
                        child: Text(
                            "Hausnummer: "
                        ),
                      ),
                      TextFormField(
                        controller: _houseNumberController,
                      ),
                      Container(
                        child: Text(
                            "Postleitzahl: "
                        ),
                      ),
                      TextFormField(
                        controller: _zipController,
                      ),
                      RaisedButton(
                          child: Text(
                              "Änderungen speichern"
                          ),
                          onPressed: () {
                            _currentUser.imagePath = _uploadedFileURL;
                            _currentUser.firstName = _firstNameController.text;
                            _currentUser.lastName = _lastNameController.text;
                            _currentUser.street = _streetController.text;
                            _currentUser.houseNumber = _houseNumberController.text;
                            _currentUser.plz = _zipController.text;
                            _currentUser.age = _currentUser.age;
                            _userService.updateUser(_currentUser);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()
                                ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ) : SizedBox.shrink(),
    );
  }

  _loadUserData() {
    _auth.getCurrentUser().then((firebaseUser) {
      _userService.getUser(firebaseUser.uid).then((fullUser) {
        _currentUser = fullUser;
        setState(() {
          //_isSubscribed = isSubscribed;
          _isDataLoaded = true;
          _firstNameController = TextEditingController(text: _currentUser.firstName);
          _lastNameController = TextEditingController(text: _currentUser.lastName);
          _streetController = TextEditingController(text: _currentUser.street);
          _houseNumberController = TextEditingController(text: _currentUser.houseNumber);
          _zipController = TextEditingController(text: _currentUser.plz);
          _uploadedFileURL = _currentUser.imagePath;
        });
      });
    });
  }

  Future _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    uploadFile();
  }


  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(
        new DateTime.now().millisecondsSinceEpoch.toString() + _image.path
            .split("/")
            ?.last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        _currentUser.imagePath = _uploadedFileURL;
      });
    });
  }
}

class RegExInputFormatter implements TextInputFormatter {
  final RegExp _regExp;

  RegExInputFormatter._(this._regExp);

  factory RegExInputFormatter.withRegex(String regexString) {
    try {
      final regex = RegExp(regexString);
      return RegExInputFormatter._(regex);
    } catch (e) {
      // Something not right with regex string.
      assert(false, e.toString());
      return null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final oldValueValid = _isValid(oldValue.text);
    final newValueValid = _isValid(newValue.text);
    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }

  bool _isValid(String value) {
    try {
      final matches = _regExp.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}