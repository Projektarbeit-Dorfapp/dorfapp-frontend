import 'package:dorf_app/models/user_model.dart';

//Meike Nedwidek
class Comment{

  int id;
  String content;
  User user; //user model missing
  String creationDate; //changes to timestamp when function to change it to minutes is there

  Comment({this.id, this.content, this.user, this.creationDate});


}