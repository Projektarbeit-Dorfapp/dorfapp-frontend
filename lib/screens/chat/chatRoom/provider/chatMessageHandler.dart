import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatMessageHandler extends ChangeNotifier{

  String _currentMessage;
  String _chatRoomID;
  ChatMessageHandler(this._chatRoomID);


  setCurrentMessage(String inputValue){
    String s = inputValue;
    s = _ltrim(s);
    s = _rtrim(s);
    _currentMessage = s;
  }
  get currentMessage => _currentMessage;
  get chatRoomID => _chatRoomID;

  Future<ChatMessage> _createMessage(BuildContext context) async{
    final access = Provider.of<AccessHandler>(context, listen: false);
    return ChatMessage(
      message: _currentMessage,
      messageFrom: await access.getUID(),
    );
  }

  sendMessage(BuildContext context, User selectedUser) async{
    final chatS = ChatService();
    final message = await _createMessage(context);
    if(_chatRoomID != null){
      chatS.sendMessage(_chatRoomID, message);
    } else {
      final access = Provider.of<AccessHandler>(context, listen: false);

      _chatRoomID = await chatS.createChat(await access.getUser(), selectedUser);
      chatS.sendMessage(_chatRoomID, message);
      notifyListeners();
    }
  }

  ///reset message
  clear(){
    _currentMessage = "";
    notifyListeners();
  }
  String _ltrim(String str) {
    return str.replaceFirst(new RegExp(r"^\s+"), "");
  }
  String _rtrim(String str) {
    return str.replaceFirst(new RegExp(r"\s+$"), "");
  }
}