import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardEntry{
  String documentID;
  String boardCategoryReference;
  int categoryColor;
  String originalDocReference; ///needs to be used on duplicates to correctly find the original document
  Timestamp lastActivity;
  Timestamp postingDate;
  String title;
  String boardCategoryTitle;
  String description;
  String caption;
  String userName;
  String firstName;
  String lastName;
  String createdBy; ///user reference
  bool isClosed;
  int watchCount;
  int likeCount;
  int commentCount;
  bool isEntry = true; ///simple identifier

  BoardEntry({
    this.categoryColor,
    this.boardCategoryReference,
    this.description,
    this.boardCategoryTitle,
    this.lastActivity,
    this.postingDate,
    this.title,
    this.userName,
    this.createdBy,
    this.watchCount,
    this.lastName,
    this.firstName});

  BoardEntry.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    boardCategoryTitle = snapshot["boardCategoryTitle"] ?? "";
    likeCount = snapshot["likeCount"] ?? 0;
    commentCount = snapshot["commentCount"] ?? 0;
    categoryColor = snapshot["categoryColor"] ?? "";
    description = snapshot["description"] ?? "";
    originalDocReference = snapshot["originalDocReference"] ?? "";
    caption = snapshot["caption"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    lastActivity = snapshot["lastActivity"] ?? null;
    postingDate = snapshot["postingDate"] ?? null;
    title = snapshot["title"] ?? "";
    userName = snapshot["userName"] ?? "";
    createdBy = snapshot ["createdBy"] ?? "";
    watchCount = snapshot["watchCount"] ?? 0;
    firstName = snapshot["firstName"] ?? "";
    lastName = snapshot["lastName"] ?? "";
    isClosed = snapshot["isClosed"] ?? false;
    isEntry = snapshot["isEntry"] ?? true;
  }
  Map<String, dynamic> toJson(){
    return {
      "boardCategoryTitle" : boardCategoryTitle,
      "categoryColor" : categoryColor,
      "description" : description,
      "originalDocReference" : originalDocReference,
      "boardCategoryReference" : boardCategoryReference,
      "lastActivity" : lastActivity,
      "postingDate" : postingDate,
      "title" : title,
      "caption" : caption,
      "userName" : userName,
      "createdBy" : createdBy,
      "watchCount" : watchCount,
      "firstName" : firstName,
      "lastName" : lastName,
      "isClosed" : isClosed,
      "isEntry" : isEntry,
    };
  }
}