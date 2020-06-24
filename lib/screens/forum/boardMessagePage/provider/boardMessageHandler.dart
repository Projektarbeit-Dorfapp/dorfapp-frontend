import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';

class BoardMessageHandler extends ChangeNotifier{
  final _authentication = Authentication();
  final _boardMessageService = BoardMessageService();
  final BoardEntry _entry;
  final BoardCategory _category;
  BoardMessageHandler(this._entry, this._category);
  String _message = "";

  get currentMessage {
    var tempMessage = "";
    if(_message.isNotEmpty){
      tempMessage = _message;
    }
    return tempMessage;
  }

  setMessage(String message){
    _message = message;
  }
  submitBoardMessage() async{
    if(_message.isEmpty){
      return;
    }
    _boardMessageService.insertBoardMessage(await _createBoardMessage());
    _message = "";
    notifyListeners();

  }
  Future<BoardMessage> _createBoardMessage() async {
    BoardMessage boardMessage;
    await _authentication.getCurrentUser().then((firebaseUser){
      boardMessage = BoardMessage(
        message: _message,
        userReference: firebaseUser.uid,
        postingDate: Timestamp.fromDate(DateTime.now()),
        boardCategoryReference: _category.id,
        boardEntryReference: _entry.id,
      );
    });
    return boardMessage;
  }
}