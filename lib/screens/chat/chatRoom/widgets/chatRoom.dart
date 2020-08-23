import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/provider/chatMessageHandler.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/messageStream.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/sendMessageField.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatelessWidget {
  final User selectedUser;
  ChatRoom({@required this.selectedUser});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatMessageHandler(),
      child: Scaffold(
        appBar: AppBar(
        ),
        body: FutureBuilder(
          future: _getChatRoomID(context),
          builder: (context, AsyncSnapshot<String> snapshot){
            if(snapshot.hasData){
              return Stack(
                children: [
                  MessageStream(selectedUser),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ChatMessageTextField(),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
    Future<String> _getChatRoomID(BuildContext context) async {
      final userS = Provider.of<UserService>(context, listen: false);
      final accessHandler = Provider.of<AccessHandler>(context, listen: false);
      return await userS.getChatRoomID(await accessHandler.getUser(), selectedUser);
    }
}
