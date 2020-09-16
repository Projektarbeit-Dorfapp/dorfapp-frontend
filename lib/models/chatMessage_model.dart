import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage {
  String documentID;
  String message;
  String messageFrom;  ///[User.uid] that created the message
  Timestamp createdAt;

  ChatMessage({this.message, this.documentID, this.createdAt, @required this.messageFrom});

  ChatMessage.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    message = snapshot["message"] ?? "";
    messageFrom = snapshot["messageFrom"] ?? "";
    createdAt = snapshot["createdAt"] ?? null;
  }
  Map<String, dynamic> toJson(){
    return {
      "message" : message,
      "messageFrom" : messageFrom,
      "createdAt" : Timestamp.now(),
    };
  }
}

class OpenChat {
  String chatID;
  User user;
  String userID;
  String role; ///creator or partner
  int unreadMessages;

  OpenChat({@required this.chatID, @required this.user, this.userID, this.role});

}