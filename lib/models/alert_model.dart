import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
///Matthias Maxelon
enum AlertType{message, news, not_defined}
class Alert{
  String documentID;
  Timestamp creationDate;
  String additionalMessage;
  String fromUserName;
  String fromFirstName;
  String fromLastName;
  String boardEntryReference;
  String boardCategoryReference;
  String topLevelCollection;
  String subCollection;
  AlertType alertType;
  Alert({
    this.topLevelCollection,
    this.boardEntryReference,
    this.boardCategoryReference,
    this.subCollection,
    this.creationDate,
    this.fromFirstName,
    this.fromLastName,
    this.fromUserName,
    this.additionalMessage,
  @required this.alertType});

  Alert.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    boardEntryReference = snapshot["boardEntryReference"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    additionalMessage = snapshot["additionalMessage"] ?? "";
    topLevelCollection = snapshot["topLevelCollection"] ?? "";
    subCollection = snapshot["subCollection"] ?? "";
    creationDate = snapshot["creationDate"] ?? null;
    fromUserName = snapshot["fromUserName"] ?? "";
    fromFirstName = snapshot["fromFirstName"] ?? "";
    fromLastName = snapshot["fromLastName"] ?? "";
    String type = snapshot["alertType"] ?? "";
    if(type == _getAlertTypeString(AlertType.message))
      alertType = AlertType.message;
    else if (type == _getAlertTypeString(AlertType.news))
      alertType = AlertType.news;
    else
      alertType = AlertType.not_defined;
  }
  Map<String, dynamic> toJson(){
    return {
      "boardEntryReference" : boardEntryReference,
      "boardCategoryReference" : boardCategoryReference,
      "additionalMessage" : additionalMessage,
      "creationDate" : creationDate,
      "topLevelCollection" : topLevelCollection,
      "subCollection" : subCollection,
      "fromUserName" : fromUserName,
      "fromFirstName" : fromFirstName,
      "fromLastName" : fromLastName,
      "alertType" : _getAlertTypeString(alertType),
    };
  }
  String _getAlertTypeString(AlertType type){
    return type.toString().split('.').last;
  }

}