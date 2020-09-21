import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/chatRoom.dart';
import 'package:dorf_app/screens/chat/chatsPage/provider/openConnectionState.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class NewUserChatDisplay extends StatelessWidget {
  final User user;
  NewUserChatDisplay({@required this.user,});
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
                40, 40),
          ),
          SizedBox(width: 10,),
          Text(user.firstName + " " + user.lastName,
          style: TextStyle(
            fontSize: 18
          ),),
        ],
      ),
    );
  }

  _navigateChatRoom(BuildContext context) async{

    Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatRoom(selectedUser: user, chatID: getChatID(context), role: null,)));
  }
  String getChatID(BuildContext context){
    final collectionState = Provider.of<OpenConnectionState>(context, listen: false);
    for(OpenChat openChat in collectionState.getOpenConnections()){
      if(openChat.user.userName == user.userName)
        return openChat.chatID;
    }
    return null;
  }
}
