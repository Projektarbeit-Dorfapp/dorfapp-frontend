import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';

///Matthias Maxelon
class BoardCategoryService{

  final _timeout = Duration(seconds: 10);
  CollectionReference _ref = Firestore.instance.collection("Forumkategorie");

  Stream<QuerySnapshot> getDocumentsAsStream(){
    return _ref.snapshots();
  }

  Future<BoardCategory> getCategory(String categoryID) async {
    final snapshot = await _ref.document(categoryID).get();
    if (snapshot.data != null){
      return BoardCategory.fromJson(snapshot.data, snapshot.documentID);
    } else{
      return null;
    }
  }

  Future<List<BoardCategory>> getBoardCategories() async {

    List<BoardCategory> boardCategories = [];

    await _ref.getDocuments()
        .then((snapshot) {
      for (var document in snapshot.documents) {
        var category = BoardCategory.fromJson(document.data, document.documentID);
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