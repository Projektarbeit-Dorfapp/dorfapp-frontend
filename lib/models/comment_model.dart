import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class Comment{

  String id;
  String content;
  User user; //firstName, lastName, userID in DB speichern
  Timestamp createdAt;
  Timestamp modifiedAt;
  String answerTo;
  bool isDeleted;

  Comment({this.id, this.content, this.user, this.createdAt, this.modifiedAt, this.answerTo, this.isDeleted});

  DateTime convertTimestamp(Timestamp timestamp) {
    if (timestamp != null) return DateTime.parse(timestamp.toDate().toString());
    return null;
  }

}