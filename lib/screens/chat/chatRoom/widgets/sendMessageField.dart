import 'package:dorf_app/screens/chat/chatRoom/provider/chatMessageHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessageTextField extends StatefulWidget {
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

    return SafeArea(
      child: Container(
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
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Icon(
                  Icons.insert_emoticon,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 6,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.82,
                child: Consumer<ChatMessageHandler>(
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
                  child: SendButton()),
            ],
          )),
    );
  }
}
class SendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _submitMessage(context);
      },
      child: Icon(
        Icons.send,
        color: Theme.of(context).buttonColor,),
    );
  }
  _submitMessage(BuildContext context) async{
    final messageHandler = Provider.of<ChatMessageHandler>(context, listen: false);
    messageHandler.clear();
    FocusScope.of(context).unfocus();
  }
}