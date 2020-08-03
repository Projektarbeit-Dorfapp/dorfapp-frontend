import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class EntryState extends ChangeNotifier{

  String title;
  String _description;

  setDescription(String desc){
    String s = desc;
    s = _ltrim(s);
    s = _rtrim(s);
    _description = s;
  }
  String _ltrim(String str) {
    return str.replaceFirst(new RegExp(r"^\s+"), "");
  }
  String _rtrim(String str) {
    return str.replaceFirst(new RegExp(r"\s+$"), "");
  }
  BoardEntry createBoardEntry( BoardCategory category, User u, Color categoryColor){
    final dateTime = DateTime.now();
    return BoardEntry(
      title: title,
      firstName: u.firstName,
      lastName: u.lastName,
      description: _description,
      categoryColor: categoryColor.value,
      userReference: u.uid,
      postingDate: Timestamp.fromDate(dateTime),
      lastModifiedDate: Timestamp.fromDate(dateTime),
      boardCategoryReference: category.documentID,
      userName: u.userName,
      userAvatarReference: u.userAvatarReference,
  );

  }
}
