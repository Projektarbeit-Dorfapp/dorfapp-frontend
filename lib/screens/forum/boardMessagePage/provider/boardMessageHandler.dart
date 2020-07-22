import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/material.dart';

class BoardMessageHandler extends ChangeNotifier {
  final _authentication = Authentication();
  final _boardMessageService = BoardMessageService();

  final BoardEntry _entry;
  final BoardCategory _category;

  BoardMessageHandler(this._entry, this._category);

  String _message = "";

  get currentMessage {
    var tempMessage = "";
    if (_message.isNotEmpty) {
      tempMessage = _message;
    }
    return tempMessage;
  }

  setMessage(String message) {
    _message = message;
  }

  submitBoardMessage(UserService userService, AlertService alertService) async {
    if (_message.isEmpty) {
      return;
    }
    var message = await _createBoardMessage(userService);
    await _boardMessageService.insertBoardMessage(message);
    _message = "";
    notifyListeners();
    _notifySubscriptions(message, alertService);
  }

  Future<BoardMessage> _createBoardMessage(UserService userService) async {
    final dateTime = DateTime.now();
    BoardMessage boardMessage;
    await _authentication.getCurrentUser().then((firebaseUser) async {
      final user = await userService.getUser(firebaseUser.uid);
      boardMessage = BoardMessage(
        firstName: user.firstName,
        lastName: user.lastName,
        userName: user.userName,
        message: _message,
        userReference: firebaseUser.uid,
        postingDate: Timestamp.fromDate(dateTime),
        lastModifiedDate: Timestamp.fromDate(dateTime),
        boardCategoryReference: _category.id,
        boardEntryReference: _entry.documentID,
      );
    });
    return boardMessage;
  }
  _notifySubscriptions(BoardMessage message, AlertService alertService) async {
    final subscriptionService = SubscriptionService();
    List<String> subscriber = await subscriptionService.getSubscriptions(
        topLevelDocumentID: message.boardEntryReference,
        topLevelCollection: CollectionNames.BOARD_ENTRY);
    Alert alert = Alert(
      alertType: AlertType.message,
      boardEntryReference: message.boardEntryReference,
      boardCategoryReference: message.boardCategoryReference,
      creationDate: message.postingDate,
      fromFirstName: message.firstName,
      fromLastName: message.lastName,
      fromUserName: message.userName,
    );
    alertService.insertAlerts(subscriber, alert);
  }
}