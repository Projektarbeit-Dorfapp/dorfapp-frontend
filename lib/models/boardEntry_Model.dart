import 'package:cloud_firestore/cloud_firestore.dart';

///Matthias Maxelon
class BoardEntry{
  String documentID;
  String boardCategoryReference;
  int categoryColor;
  String userReference; ///creator of BoardEntry
  String originalDocReference; ///needs to be used on duplicates to correctly find the original document
  Timestamp lastModifiedDate;
  Timestamp postingDate;
  String title;
  String description;
  String caption;
  String userName;
  String firstName;
  String lastName;
  String userAvatarReference;
  bool isClosed;
  int watchCount;
  bool isEntry = true; ///simple identifier

  BoardEntry({
    this.categoryColor,
    this.boardCategoryReference,
    this.userReference,
    this.description,
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
    categoryColor = snapshot["categoryColor"] ?? "";
    description = snapshot["description"] ?? "";
    originalDocReference = snapshot["originalDocReference"] ?? "";
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
    isEntry = snapshot["isEntry"] ?? true;
  }
  Map<String, dynamic> toJson(){
    return {
      "categoryColor" : categoryColor,
      "description" : description,
      "originalDocReference" : originalDocReference,
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
      "isEntry" : isEntry,
    };
  }
}