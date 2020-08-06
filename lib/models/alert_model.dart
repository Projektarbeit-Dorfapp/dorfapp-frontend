import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
///Matthias Maxelon
enum AlertType{message, news, pin_notification, not_defined} ///If you add new AlertTypes: make sure that inside [_convertType()] is correctly converted into new type
class Alert{
  String documentID;
  Timestamp creationDate;
  String additionalMessage;
  String headline; ///The name of the content, if news -> maybe save news headline here or if boardEntry -> save headline of entry
  bool isRead; /// is true if user has read the alert
  String fromUserName;
  String fromFirstName;
  String fromLastName;
  String boardEntryReference;
  String boardCategoryReference;

  AlertType alertType;
  Alert({
    this.headline,
    this.boardEntryReference,
    this.boardCategoryReference,
    this.creationDate,
    this.fromFirstName,
    this.fromLastName,
    this.fromUserName,
    this.additionalMessage,
  @required this.alertType});

  Alert.fromJson(Map snapshot, String documentID){
    this.documentID = documentID;
    isRead = snapshot["isRead"] ?? false;
    headline = snapshot["headline"] ?? "";
    boardEntryReference = snapshot["boardEntryReference"] ?? "";
    boardCategoryReference = snapshot["boardCategoryReference"] ?? "";
    additionalMessage = snapshot["additionalMessage"] ?? "";
    creationDate = snapshot["creationDate"] ?? null;
    fromUserName = snapshot["fromUserName"] ?? "";
    fromFirstName = snapshot["fromFirstName"] ?? "";
    fromLastName = snapshot["fromLastName"] ?? "";
    String type = snapshot["alertType"] ?? "";
    _convertType(type);
  }
  Map<String, dynamic> toJson(){
    return {
      "headline" : headline,
      "boardEntryReference" : boardEntryReference,
      "boardCategoryReference" : boardCategoryReference,
      "additionalMessage" : additionalMessage,
      "creationDate" : creationDate,
      "fromUserName" : fromUserName,
      "fromFirstName" : fromFirstName,
      "fromLastName" : fromLastName,
      "alertType" : _getAlertTypeString(alertType),
    };
  }
  String _getAlertTypeString(AlertType type){
    return type.toString().split('.').last;
  }
  _convertType(String type){
    if(type == _getAlertTypeString(AlertType.message))
      alertType = AlertType.message;
    else if (type == _getAlertTypeString(AlertType.news))
      alertType = AlertType.news;
    else if(type == _getAlertTypeString(AlertType.pin_notification))
      alertType = AlertType.pin_notification;
    else
      alertType = AlertType.not_defined;
  }
}