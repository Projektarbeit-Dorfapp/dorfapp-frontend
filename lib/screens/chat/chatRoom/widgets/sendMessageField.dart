import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/provider/chatMessageHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessageTextField extends StatefulWidget {
  final String chatRoomID;
  final User selectedUser;
  ChatMessageTextField({@required this.chatRoomID, @required this.selectedUser});
  @override
  _ChatMessageTextFieldState createState() => _ChatMessageTextFieldState();
}

class _ChatMessageTextFieldState extends State<ChatMessageTextField> {
  TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.1,
              blurRadius: 4,
              offset: Offset(0, -1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.87,
              child: Consumer<ChatRoomHandler>(
                builder: (context, messageHandler,_){
                  _controller.text = messageHandler.currentMessage;
                  return TextFormField(
                    controller: _controller,
                    onChanged: (textValue) {
                      messageHandler.setCurrentMessage(textValue);
                    },
                    style: TextStyle(
                      fontFamily: "Raleway",
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Schreib was"),
                  );
                },
              ),
            ),
            Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: SendButton(chatRoomID: widget.chatRoomID, selectedUser: widget.selectedUser,)),
          ],
        ));
  }
}
class SendButton extends StatelessWidget {
  final String chatRoomID;
  final User selectedUser;
  SendButton({@required this.chatRoomID, @required this.selectedUser});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _submitMessage(context, selectedUser);
      },
      child: Icon(
        Icons.send,
        color: Theme.of(context).buttonColor,),
    );
  }
  _submitMessage(BuildContext context, User selectedUser) async{
    final messageHandler = Provider.of<ChatRoomHandler>(context, listen: false);
    messageHandler.sendMessage(context, selectedUser);
    messageHandler.clear();
  }
}