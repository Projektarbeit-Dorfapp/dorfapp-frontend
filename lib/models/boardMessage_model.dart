import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardMessage{
  String documentID;
  String boardCategoryReference;
  String boardEntryReference;
  String userReference;
  Timestamp lastModifiedDate;
  Timestamp postingDate;
  String userName;
  String firstName;
  String lastName;
  String message;

  BoardMessage({
  this.boardEntryReference,
  this.postingDate,
  this.lastModifiedDate,
  this.message,
  this.boardCategoryReference,
  this.userReference,
  this.userName,
  this.lastName,
  this.firstName});

  BoardMessage.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    boardEntryReference = snapshot["boardEntryReference"] ?? "";
    userReference = snapshot["userReference"] ?? "";
    lastModifiedDate = snapshot["lastModifiedDate"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    message = snapshot["message"] ?? "";
    userName = snapshot["userName"] ?? "";
    firstName = snapshot["firstName"] ?? "";
    lastName = snapshot["lastName"] ?? "";
  }
  Map<String, dynamic> toJson(){
    return {
      "boardEntryReference" : boardEntryReference,
      "boardCategoryReference" : boardCategoryReference,
      "userReference" : userReference,
      "lastModifiedDate" : lastModifiedDate,
      "message" : message,
      "postingDate" : postingDate,
      "userName" : userName,
      "firstName" : firstName,
      "lastName" : lastName,
    };
  }
}