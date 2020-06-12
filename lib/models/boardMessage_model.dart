import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardMessage{
  String id;
  String boardCategoryReference;
  String boardEntryReference;
  String userReference;
  Timestamp lastModifiedDate;
  Timestamp postingDate;
  String message;

  BoardMessage(
  this.boardEntryReference,
  this.postingDate,
  this.lastModifiedDate,
  this.message,
  this.boardCategoryReference,
  this.userReference);

  BoardMessage.fromJson(Map snapshot, String id){
    this.id = id;
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    boardEntryReference = snapshot["boardEntryReference"] ?? "";
    userReference = snapshot["userReference"] ?? "";
    lastModifiedDate = snapshot["lastModifiedDate"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    message = snapshot["message"] ?? "";
  }

  Map<String, dynamic> toJson(){
    return {
      "boardEntryReference" : boardEntryReference,
      "boardCategoryReference" : boardCategoryReference,
      "userReference" : userReference,
      "lastModifiedDate" : lastModifiedDate,
      "message" : message,
      "postingDate" : postingDate,
    };
  }
}