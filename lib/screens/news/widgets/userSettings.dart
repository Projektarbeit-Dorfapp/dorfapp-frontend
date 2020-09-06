import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {

  final currentUser;

  UserSettings(this.currentUser);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.clear
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff6FB3A9),
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
                      image: widget.currentUser.imagePath != "" ? NetworkImage(widget.currentUser.imagePath)
                          : AssetImage("assets/avatar.png"),
                      fit: BoxFit.fill,
                    ),
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Text(widget.currentUser.userName,
              style: TextStyle(
                fontFamily: "Raleway",
                fontSize: 16
              ),),
            ],
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Icon(Icons.accessibility_new, color: Color(0xff6FB3A9)
                    ),
                  ),
                  Text("Mein Profil",
                    style: TextStyle(
                        fontFamily: "Raleway",
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(Icons.notification_important, color: Color(0xff6FB3A9),
                  ),
                ),
                Text("Meine Benachrichtigungen",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(Icons.favorite, color: Color(0xff6FB3A9)
                  ),
                ),
                Text("Meine Favoriten",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),


          Divider(thickness: 2,),

          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(Icons.settings, color: Color(0xff6FB3A9)
                  ),
                ),
                Text("Einstellungen",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Icon(Icons.account_box, color: Color(0xff6FB3A9),
                  ),
                ),
                Text("Mein Account wechseln",
                  style: TextStyle(
                      fontFamily: "Raleway",
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
