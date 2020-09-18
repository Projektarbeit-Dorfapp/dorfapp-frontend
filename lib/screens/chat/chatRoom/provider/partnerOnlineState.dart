import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/cupertino.dart';

class PartnerOnlineState extends ChangeNotifier {
  final String _offlineState = "Offline";
  final String _onlineState = "Online";
  Stream<DocumentSnapshot> _chatDocumentStream;
  StreamSubscription _subscription;
  String _chatRoomID;
  bool _isCreatorOnline = false;
  bool _isPartnerOnline = false;
  ChatService chatService = ChatService();

  get isCreatorOnline => _isCreatorOnline;
  get isPartnerOnline => _isPartnerOnline;

  PartnerOnlineState(String chatRoomID){
    _chatRoomID = chatRoomID;
    initStream();
  }

  dispose(){
    disposeSubscription();
    super.dispose();
  }

  initStream() {
    _chatDocumentStream = chatService.chatDocumentStream(_chatRoomID).handleError((onError) {
      print(onError);
      return;
    });
    if(_chatRoomID != null)
      _listenStream();
  }

  _listenStream() {
    try{
      _subscription = _chatDocumentStream.listen((snapshot) {
        _isCreatorOnline = snapshot.data["isCreatorOnline"] ?? null;
        _isPartnerOnline = snapshot.data["isPartnerOnline"] ?? null;
        notifyListeners();
      });
    }catch(e){
      print(e);
    }
  }

  disposeSubscription() async {
    if (_subscription != null) await _subscription.cancel();
    _subscription = null;
  }

  String getPartnerOnlineState(String clientRole){
    if(_chatRoomID == null)
      return "";


    switch(clientRole){
      case ("partner"):
        if(_isCreatorOnline)
          return _onlineState;
        else
          return _offlineState;
        break;
      case ("creator"):
        if(_isPartnerOnline)
          return _onlineState;
        else
          return _offlineState;
        break;
      default:
        return "";
        break;
    }
  }
}
