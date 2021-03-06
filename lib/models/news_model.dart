import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class News{

  String id;
  String title;
  String description;
  Timestamp startTime;
  Timestamp endTime;
  Address address;
  String imagePath;
  List<User> likes;
  List<TopComment> comments;
  List<User> bookmarks;
  bool isNews;
  Timestamp createdAt;
  Timestamp modifiedAt;
  String createdBy;

  News({this.id, this.title, this.description, this.startTime, this.endTime, this.address, this.imagePath, this.likes, this.comments, this.isNews, this.createdAt, this.modifiedAt, this.createdBy, this.bookmarks});

  DateTime convertTimestamp(Timestamp timestamp) {
    if (timestamp != null) return DateTime.parse(timestamp.toDate().toString());
    return null;
  }
}