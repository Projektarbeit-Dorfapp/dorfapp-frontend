import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/chatRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserDisplay extends StatelessWidget {
  final OpenChat openChat;
  UserDisplay({@required this.openChat});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ChatRoom(selectedUser: openChat.user, chatID: openChat.chatID, role: openChat.role)));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              UserAvatarDisplay(50, 50),
              SizedBox(width: 20,),
              Text(openChat.user.firstName + " " + openChat.user.lastName, style: TextStyle(
                  fontSize: 20
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
