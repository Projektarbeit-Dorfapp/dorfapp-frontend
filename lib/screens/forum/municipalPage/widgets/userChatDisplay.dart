import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/userAvatarDisplay.dart';
import 'package:dorf_app/screens/forum/municipalPage/chatRoom.dart';
import 'package:dorf_app/widgets/showUserProfileText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDisplay extends StatelessWidget {
  final User user;
  UserDisplay({@required this.user});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ChatRoom()));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.13,
                  child: ShowUserProfileText(
                    userReference: user.uid,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userName: user.userName,
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UserAvatarDisplay(40, 40
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
