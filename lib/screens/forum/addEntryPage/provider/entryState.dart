import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class EntryState extends ChangeNotifier{

  String title;


  BoardEntry createBoardEntry(String userID, BoardCategory category, User u){
    final dateTime = DateTime.now();
    return BoardEntry(
      title: title,
      userReference: userID,
      postingDate: Timestamp.fromDate(dateTime),
      lastModifiedDate: Timestamp.fromDate(dateTime),
      boardCategoryReference: category.documentID,
      userName: u.userName,
      userAvatarReference: u.userAvatarReference,
  );

  }
}
