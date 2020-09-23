import 'dart:io';

import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/chatRoom.dart';
import 'package:dorf_app/screens/chat/chatsPage/provider/openConnectionState.dart';
import 'package:dorf_app/screens/login/loginPage/loginPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flushbar/flushbar.dart';
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
            child: UserAvatar(height: 40, width: 40, userID: user.uid,),
          ),
          SizedBox(width: 10,),
          Flexible(
            child: Text(user.firstName + " " + user.lastName,
            style: TextStyle(
              fontSize: 18
            ),),
          ),
        ],
      ),
    );
  }

  _navigateChatRoom(BuildContext context) async{
    String chatID = getChatID(context);
    if(chatID != null){
      Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatRoom(selectedUser: user, chatID: chatID, role: null,)));
    } else {
      _showCreateChatDialog(context);
    }

  }
  String getChatID(BuildContext context){
    final collectionState = Provider.of<OpenConnectionState>(context, listen: false);
    for(OpenChat openChat in collectionState.getOpenConnections()){
      if(openChat.user.documentID == user.documentID)
        return openChat.chatID;
    }
    return null;
  }
  _showCreateChatDialog(BuildContext context){
    showDialog(context: context,
        builder: (BuildContext context){
          return CreateChatDialog(user);
        });
  }
}
class CreateChatDialog extends StatelessWidget {
  final User selectedUser;
  CreateChatDialog(this.selectedUser);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Möchtest du mit "${selectedUser.firstName} ${selectedUser.lastName}" chatten?'),
      actions: [
        FlatButton(
          child: Text("Ja", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17),),
          onPressed: () async{
            try {
              final result = await InternetAddress.lookup('example.com');
              if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                Navigator.push(context, LoadingOverlay());
                String chatID = await _createChat(context, selectedUser);
                Navigator.pop(context);
                if(chatID == null){
                  _showErrorMessage(context);
                } else {
                  _dismiss(context);
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatRoom(selectedUser: selectedUser, chatID: chatID, role: null,)));
                }
              }
            } on SocketException catch (_) {
              _showErrorMessage(context);
            }
          },
        ),
        FlatButton(
          child: Text("Nein", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17),),
          onPressed: (){
            _dismiss(context);
          },
        ),
      ],
    );
  }
  _showErrorMessage(BuildContext context){
    Flushbar(
      messageText: Center(
        child: const Text("Etwas ist schief gelaufen, versuche es später erneut", style: TextStyle(
            fontFamily: "Raleway",
            color: Colors.white,
            fontSize: 17
        ),),
      ),
      duration: const Duration(seconds: 2),
    )..show(context);
  }
  _dismiss(BuildContext context){
    Navigator.pop(context);
  }
 Future<String> _createChat(BuildContext context, User selectedUser) async{
     User currentUser = await Provider.of<AccessHandler>(context, listen: false).getUser();
     final chatS = ChatService();
     String chatID = await chatS.createChat(currentUser, selectedUser);
     return chatID;
  }
}

