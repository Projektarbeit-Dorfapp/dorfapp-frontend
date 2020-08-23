import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/chatRoom.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewUserChatDisplay extends StatelessWidget {
  final User user;
  NewUserChatDisplay({@required this.user});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _navigateChatRoom(context);
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: UserAvatarDisplay(
                50, 50),
          ),
          SizedBox(width: 10,),
          Text(user.firstName + " " + user.lastName,
          style: TextStyle(
            fontSize: 20
          ),),
        ],
      ),
    );
  }

  _navigateChatRoom(BuildContext context) async{
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatRoom(selectedUser: user,)));
  }
}
