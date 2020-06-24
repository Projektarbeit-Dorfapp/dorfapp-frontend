import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:flutter/cupertino.dart';

class EntryState extends ChangeNotifier{

  String title;


  BoardEntry createBoardEntry(String userID, BoardCategory category){
  return BoardEntry(
    title: title,
    userReference: userID,
    postingDate: Timestamp.fromDate(DateTime.now()),
    boardCategoryReference: category.id,
  );

  }
}
