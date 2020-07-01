import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardEntry{
  String id;
  String boardCategoryReference;
  String userReference;
  Timestamp lastModifiedDate;
  Timestamp postingDate;
  String title;
  String caption;
  String userName; //speedTest for faster query
  String userAvatarReference; //speed test for faster query
  int watchCount;

  BoardEntry({
    this.boardCategoryReference,
    this.userReference,
    this.lastModifiedDate,
    this.postingDate,
    this.title,
    this.userName,
    this.userAvatarReference,
    this.watchCount});

  BoardEntry.fromJson(Map snapshot, String id){
    this.id = id;
    caption = snapshot["caption"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    userReference = snapshot["userReference"] ?? "";
    lastModifiedDate = snapshot["lastModifiedDate"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    title = snapshot["title"] ?? "";
    userName = snapshot["userName"] ?? "";
    userAvatarReference = snapshot ["userAvatarReference"] ?? "";
    watchCount = snapshot["watchCount"];
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
    };
  }
}