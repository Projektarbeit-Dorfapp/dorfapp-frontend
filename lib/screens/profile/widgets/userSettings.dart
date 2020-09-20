import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/profile/widgets/changeUserAccount.dart';
import 'package:dorf_app/screens/profile/widgets/myAlerts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  AccessHandler _accessHandler;
  User _loggedUser;
  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _accessHandler.getUser().then((user) {
      if(mounted)
        setState(() {
          _loggedUser = user;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loggedUser != null ? Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.clear),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _loggedUser.imagePath != "" ? NetworkImage(_loggedUser.imagePath)
                          : AssetImage("assets/avatar.png"),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              _loggedUser != null
                  ? Text(
                      _loggedUser.userName,
                      style: TextStyle(fontFamily: "Raleway", fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Container()
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Icon(Icons.accessibility_new, color: Theme.of(context).buttonColor),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Text("Mein Profil",
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 16
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20, bottom: 10), child: MyAlerts()),

          Divider(
            thickness: 2,
            indent: MediaQuery.of(context).size.width * 0.06,
            endIndent: MediaQuery.of(context).size.width * 0.06,
          ),
          Padding(padding: EdgeInsets.only(top: 10), child: ChangeUserAccount()),
        ],
      ),
    ) : Center(child: CircularProgressIndicator());
  }
}
