import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class Comment{

  int id;
  String content;
  User user;
  DateTime creationDate;

  Comment({this.id, this.content, this.user, this.creationDate});


}