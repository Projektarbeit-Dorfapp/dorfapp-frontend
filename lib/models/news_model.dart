import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class NewsModel{

  String title;
  String description;
  DateTime start;
  DateTime end;
  Address address;
  String imagePath;
  List<User> likes;
  List<Comment> comments;

  NewsModel({this.title, this.description, this.start, this.end, this.address, this.imagePath, this.likes, this.comments});

}