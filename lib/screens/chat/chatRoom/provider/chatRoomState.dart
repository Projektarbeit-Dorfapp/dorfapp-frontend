import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/cupertino.dart';

class ChatRoomState extends ChangeNotifier {
  Stream<DocumentSnapshot> _chatDocumentStream;
  StreamSubscription _subscription;
  String _chatRoomID;
  bool _isCreatorOnline;
  bool _isPartnerOnline;

  get isCreatorOnline => _isCreatorOnline;
  get isPartnerOnline => _isPartnerOnline;

  ChatRoomState(this._chatRoomID);
  ChatService chatService = ChatService();

  initStream() {
    _chatDocumentStream = chatService.chatDocumentStream(_chatRoomID).handleError((onError) {
      print(onError);
    });
    _listenStream();
  }

  _listenStream() {
    try{
      _subscription = _chatDocumentStream.listen((snapshot) {
        _isCreatorOnline = snapshot.data["isCreatorOnline"] ?? null;
        _isPartnerOnline = snapshot.data["isPartnerOnline"] ?? null;
      });
    }catch(e){
      print(e);
    }
  }

  disposeSubscription() async {
    if (_subscription != null) await _subscription.cancel();
    _subscription = null;
  }
}
