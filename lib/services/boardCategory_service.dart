import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class BoardCategoryService extends ChangeNotifier{

  final _timeout = Duration(seconds: 10);
  CollectionReference _ref = Firestore.instance.collection("Forumkategorie");

  Stream<QuerySnapshot> getDocumentsAsStream(){
    return _ref.snapshots();
  }
  Future<List<BoardCategory>> getBoardCategories() async {

    List<BoardCategory> boardCategories = [];

    await _ref.getDocuments()
        .then((snapshot) {
      for (var document in snapshot.documents) {
        var category = BoardCategory.fromJson(document.data);
        category.id = document.documentID;
        boardCategories.add(category);
      }
    }).timeout(_timeout, onTimeout: () {
      print("timeout on Service: BoardCategoryService in: [getBoardCategories()]");
      throw Exception();
    }).catchError((error) {
      print("Developermessage ERROR: " + error);
      throw Exception();
    });
    return boardCategories;

  }
}