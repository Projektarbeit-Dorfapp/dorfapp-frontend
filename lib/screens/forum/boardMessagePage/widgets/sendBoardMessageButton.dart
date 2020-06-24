import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendBoardMessageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
       _submitBoardMessage(context);
      },
      child: Icon(
        Icons.send,
        color: Colors.lightGreen,),
    );
  }
  _submitBoardMessage(BuildContext context){
    final messageHandler = Provider.of<BoardMessageHandler>(context, listen: false);
    print("buttonpress");
    messageHandler.submitBoardMessage();
    FocusScope.of(context).unfocus();
  }
}
