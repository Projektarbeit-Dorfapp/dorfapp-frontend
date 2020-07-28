import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardEntry{
  String documentID;
  String boardCategoryReference;
  String userReference; ///creator of BoardEntry
  Timestamp lastModifiedDate;
  Timestamp postingDate;
  String title;
  String caption;
  String userName;
  String firstName;
  String lastName;
  String userAvatarReference;
  bool isClosed;
  int watchCount;

  BoardEntry({
    this.boardCategoryReference,
    this.userReference,
    this.lastModifiedDate,
    this.postingDate,
    this.title,
    this.userName,
    this.userAvatarReference,
    this.watchCount,
    this.lastName,
    this.firstName});

  BoardEntry.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    caption = snapshot["caption"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    userReference = snapshot["userReference"] ?? "";
    lastModifiedDate = snapshot["lastModifiedDate"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    title = snapshot["title"] ?? "";
    userName = snapshot["userName"] ?? "";
    userAvatarReference = snapshot ["userAvatarReference"] ?? "";
    watchCount = snapshot["watchCount"] ?? 0;
    firstName = snapshot["firstName"] ?? "";
    lastName = snapshot["lastName"] ?? "";
    isClosed = snapshot["isClosed"] ?? false;
  }
  Map<String, dynamic> toJson(){
    return {
      "boardCategoryReference" : boardCategoryReference,
      "userReference" : userReference,
      "lastModifiedDate" : lastModifiedDate,
      "postingDate" : postingDate,
      "title" : title,
      "caption" : caption,
      "userName" : userName,
      "userAvatarReference" : userAvatarReference,
      "watchCount" : watchCount,
      "firstName" : firstName,
      "lastName" : lastName,
      "isClosed" : isClosed,
    };
  }
}