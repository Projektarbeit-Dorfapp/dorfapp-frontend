import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
///Matthias Maxelon
enum AlertType{boardMessage, eventMessage, news, pin_notification, not_defined, entry} ///If you add new AlertTypes: make sure that inside [_convertType()] is correctly converted into new type
class Alert{
  String documentID;
  Timestamp creationDate;
  String additionalMessage;
  String headline; ///The name of the content, if news -> maybe save news headline here or if boardEntry -> save headline of entry
  bool isRead; /// is true if user has read the alert
  String fromUserName;
  String fromFirstName;
  String fromLastName;
  String documentReference;

  AlertType alertType;
  Alert({
    this.headline,
    this.documentReference,
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
    documentReference = snapshot["documentReference"] ?? "";
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
      "documentReference" : documentReference,
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
    if(type == _getAlertTypeString(AlertType.boardMessage))
      alertType = AlertType.boardMessage;
    else if (type == _getAlertTypeString(AlertType.news))
      alertType = AlertType.news;
    else if(type == _getAlertTypeString(AlertType.pin_notification))
      alertType = AlertType.pin_notification;
    else if (type == _getAlertTypeString(AlertType.eventMessage))
      alertType = AlertType.eventMessage;
    else if (type == _getAlertTypeString(AlertType.entry))
      alertType = AlertType.entry;
    else
      alertType = AlertType.not_defined;
  }
}