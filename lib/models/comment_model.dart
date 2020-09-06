import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class Comment{

  String id;
  String content;
  String firstName;
  String lastName;
  String userID;
  User user; //firstName, lastName, userID in DB speichern
  Timestamp createdAt;
  Timestamp modifiedAt;
  String answerTo;
  bool isDeleted;

  Comment({this.id, this.content, this.user, this.createdAt, this.modifiedAt, this.answerTo, this.isDeleted, this.firstName, this.lastName, this.userID});

  DateTime convertTimestamp(Timestamp timestamp) {
    if (timestamp != null) return DateTime.parse(timestamp.toDate().toString());
    return null;
  }
}