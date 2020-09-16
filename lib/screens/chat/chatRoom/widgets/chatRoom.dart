import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/provider/chatMessageHandler.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/messageStream.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/sendMessageField.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final User selectedUser;
  final String chatID;
  final String role;
  ChatRoom({@required this.selectedUser, @required this.chatID, @required this.role});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  User _loggedUser;
  @override
  void initState() {
    final chatS = ChatService();
    Provider.of<AccessHandler>(context, listen: false).getUser().then((value){
      if(mounted){
        setState(() {
          chatS.goOnline(value, widget.selectedUser, widget.chatID, widget.role);
          _loggedUser = value;
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _loggedUser != null ? ChangeNotifierProvider(
      create: (context) => ChatMessageHandler(widget.chatID),
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, "/profilePage", arguments: widget.selectedUser.uid);
            },
            child: Row(
              children: [
                UserAvatarDisplay(40, 40),
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                      widget.selectedUser.firstName + " " + widget.selectedUser.lastName),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Consumer<ChatMessageHandler>(
              builder: (context, chatMessageHandler, _){
                return chatMessageHandler.chatRoomID != null ? MessageStream(_loggedUser, chatMessageHandler.chatRoomID) : Expanded(child: Container());
              },
            ),
            SizedBox(height: 5,),
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatMessageTextField(chatRoomID: widget.chatID, selectedUser: widget.selectedUser),
            ),
          ],
        ),
      ),
    ) : Center(
      child: CircularProgressIndicator(),
    );
  }
}
class ChatRoomUserRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        UserAvatarDisplay(10, 10),
      ],
    );
  }
}




