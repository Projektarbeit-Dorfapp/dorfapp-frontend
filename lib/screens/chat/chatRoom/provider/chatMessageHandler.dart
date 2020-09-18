import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class ChatRoomHandler extends ChangeNotifier with WidgetsBindingObserver{

  String _currentMessage;
  String _chatRoomID;
  String _clientRole;
  User _loggedUser;
  User _selectedUser;

  get currentMessage => _currentMessage;
  get chatRoomID => _chatRoomID;
  get role => _clientRole;

  ChatRoomHandler(String chatRoomID, String currentRole, User loggedUser, User selectedUser){
    this._chatRoomID = chatRoomID;
    this._clientRole = currentRole;
    this._loggedUser = loggedUser;
    this._selectedUser = selectedUser;
    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    _goOffline();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  _goOffline(){
    final chatS = ChatService();
    if(_chatRoomID != null){
      chatS.goOffline(_loggedUser, _selectedUser, _chatRoomID, _clientRole);
    }
  }
  _goOnline(){
    final chatS = ChatService();
    if(_chatRoomID != null){
      chatS.goOnline(_loggedUser, _selectedUser, _chatRoomID, _clientRole);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _goOnline();
        break;
      case AppLifecycleState.inactive:
        _goOffline();
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
  setCurrentMessage(String inputValue){
    String s = inputValue;
    s = _ltrim(s);
    s = _rtrim(s);
    _currentMessage = s;
  }


  Future<ChatMessage> _createMessage(BuildContext context) async{
    final access = Provider.of<AccessHandler>(context, listen: false);
    return ChatMessage(
      message: _currentMessage,
      messageFrom: await access.getUID(),
    );
  }
  
  Future<bool> _isSelectedUserOnline() async{
    
    DocumentSnapshot querySnapshot = await Firestore.instance.collection(CollectionNames.CHAT).document(_chatRoomID).get();
    bool status;
    switch(_clientRole){
      case ("partner"):
        if(querySnapshot.data["isCreatorOnline"] == true)
          status = true;
        else
          status = false;
        break;
      case ("creator"):
        if(querySnapshot.data["isPartnerOnline"] == true)
          status = true;
        else
          status = false;
        break;
      default:
        break;
    }
    return status;
  }

  _incrementUnread() async{
    if(await _isSelectedUserOnline() == false){
     QuerySnapshot snapshot = await Firestore.instance.collection(CollectionNames.USER).document(_selectedUser.documentID).collection(CollectionNames.CHATS).where("chatID", isEqualTo: _chatRoomID).getDocuments();
      String docIDToUpdate = snapshot.documents[0].documentID;
      Firestore.instance.collection(CollectionNames.USER).document(_selectedUser.documentID).collection(CollectionNames.CHATS).document(docIDToUpdate).updateData({"unreadMessages" : FieldValue.increment(1)});
    }
  }

  sendMessage(BuildContext context, User selectedUser) async{
    final chatS = ChatService();
    final message = await _createMessage(context);
    if(_chatRoomID != null){
      chatS.sendMessage(_chatRoomID, message);
      _incrementUnread();
    } else {
      final access = Provider.of<AccessHandler>(context, listen: false);
      _chatRoomID = await chatS.createChat(await access.getUser(), selectedUser);
      chatS.sendMessage(_chatRoomID, message);
      _incrementUnread();
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