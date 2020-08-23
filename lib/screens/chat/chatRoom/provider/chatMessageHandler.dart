
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatMessageHandler extends ChangeNotifier{

  String _currentMessage;

  setCurrentMessage(String inputValue){
    _currentMessage = inputValue;
  }
  get currentMessage => _currentMessage;

  Future<ChatMessage> _createMessage(BuildContext context) async{
    final access = Provider.of<AccessHandler>(context, listen: false);
    return ChatMessage(
      messageFrom: await access.getUID(),
      message: _currentMessage
    );
  }
  sendMessage(BuildContext context, String chatRoomID) async{
    final message = await _createMessage(context);
    //TODO: CHATSERVICE.SEND(String chatRoomID, ChatMessage message);
  }

  ///reset message
  clear(){
    _currentMessage = "";
    notifyListeners();
  }
}