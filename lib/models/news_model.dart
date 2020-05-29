import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class NewsModel{

  String id;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  Address address;
  String imagePath;
  List<User> likes;
  List<Comment> comments;
  bool isNews;
  DateTime createdAt;
  DateTime modifiedAt;

  NewsModel({this.id, this.title, this.description, this.startTime, this.endTime, this.address, this.imagePath, this.likes, this.comments, this.isNews, this.createdAt, this.modifiedAt});

}