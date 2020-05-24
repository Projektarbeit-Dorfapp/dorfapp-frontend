import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/comment_model.dart';

class NewsModel{

  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  DateTime createdAt;
  DateTime modifiedAt;
  Address address;
  String imagePath;
  List<int> like;
  List<Comment> comments;

  NewsModel({this.title, this.description, this.startTime, this.endTime, this.createdAt, this.modifiedAt,  this.address, this.imagePath, this.like, this.comments});

}