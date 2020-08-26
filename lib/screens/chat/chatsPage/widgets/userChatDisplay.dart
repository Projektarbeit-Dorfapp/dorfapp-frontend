import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/chatRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDisplay extends StatelessWidget {
  final User user;
  UserDisplay({@required this.user});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ChatRoom(selectedUser: user,)));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5),
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              UserAvatarDisplay(50, 50),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text("UserName Display", style: TextStyle(
                    fontSize: 20
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
