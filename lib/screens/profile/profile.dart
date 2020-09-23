import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/profile/widgets/profile_edit.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:dorf_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  UserService _userService;
  Authentication _auth;
  User _currentUser;
  bool _isDataLoaded = false;

  @override
  void initState() {
    _userService = Provider.of<UserService>(context, listen: false);
    _auth = Provider.of<Authentication>(context, listen: false);
    _loadUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = true;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profil',),
        actions: <Widget>[
          PopupMenuButton<String>(
            color: Colors.white,
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (String choice) async {
              if (choice == 'Edit') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileEdit()));
              }  else if (choice == 'Logout') {
              }
            },
            itemBuilder: (BuildContext context) {
              return ([
                isOwnProfile
                    ? PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Profil editieren'),
                  )
                    : null,
                isOwnProfile
                    ? PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text('Ausloggen'),
                  )
                    : null,
              ]).toList();
            },
          ),
        ],
      ),
      body: _isDataLoaded ? Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              height: 150,
              width: 150,
              child: new Padding(
                child: new CircleAvatar(
                  radius: 80,
                  backgroundImage: _currentUser.imagePath != "" ? NetworkImage(_currentUser.imagePath)
                      : AssetImage("assets/avatar.png")
                ),
                padding: EdgeInsets.only(top: 10, left: 10),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('Vorname: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
                        ),
                        _currentUser.firstName != "" ? Container(
                          child: Text(
                            _currentUser.firstName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Nachname: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        _currentUser.lastName != "" ? Container(
                          child: Text(
                            _currentUser.lastName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Alter: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        _currentUser.age > 0 ? Container(
                          child: Text(
                            _currentUser.age.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Straße: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        _currentUser.street != "" ? Container(
                          child: Text(
                            _currentUser.street,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Hausnummer: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        _currentUser.houseNumber != "" ? Container(
                          child: Text(
                            _currentUser.houseNumber,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Postleitzahl: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        _currentUser.plz != "" ? Container(
                          child: Text(
                            _currentUser.plz,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Ort: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                        _currentUser.municipalReference != "" ? Container(
                          child: Text(
                            _currentUser.municipalReference,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ) : SizedBox.shrink(),
                      ],
                    ),
                  ],
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
        });
      });
    });
  }


}
