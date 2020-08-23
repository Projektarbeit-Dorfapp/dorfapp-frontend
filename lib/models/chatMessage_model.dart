import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatMessage{
  String documentID;
  String message;
  String messageFrom;  ///[User.uid] that created the message
  Timestamp createdAt;

  ChatMessage({this.message, @required this.messageFrom});

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