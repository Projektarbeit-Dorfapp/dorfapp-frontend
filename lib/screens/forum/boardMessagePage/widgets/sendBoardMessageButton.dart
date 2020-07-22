import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/user_service.dart';
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
        color: Theme.of(context).buttonColor,),
    );
  }
  _submitBoardMessage(BuildContext context) async{
    final messageHandler = Provider.of<BoardMessageHandler>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final alertService = Provider.of<AlertService>(context, listen: false);
    messageHandler.submitBoardMessage(userService, alertService);
    FocusScope.of(context).unfocus();
  }
}
