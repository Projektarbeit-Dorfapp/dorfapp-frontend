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

  BoardEntry({this.boardCategoryReference, this.userReference, this.lastModifiedDate, this.postingDate, this.title});
  BoardEntry.fromJson(Map snapshot, String id){
    this.id = id;
    caption = snapshot["caption"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    userReference = snapshot["userReference"] ?? "";
    lastModifiedDate = snapshot["lastModifiedDate"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    title = snapshot["title"] ?? "";
  }
  Map<String, dynamic> toJson(){
    return {
      "boardCategoryReference" : boardCategoryReference,
      "userReference" : userReference,
      "lastModifiedDate" : lastModifiedDate,
      "postingDate" : postingDate,
      "title" : title,
      "caption" : caption,
    };
  }
}