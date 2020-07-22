import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';


///Matthias Maxelon
class BoardEntryService{
  final CollectionReference _boardRef = Firestore.instance.collection("Forumeintrag");
  insertEntry(BoardEntry entry) async {
    await _boardRef.add(entry.toJson());
  }
  incrementWatchCount(BoardEntry entry){
    _boardRef.document(entry.documentID).updateData({"watchCount" : FieldValue.increment(1)});
  }
  closeBoardEntry(BoardEntry entry){
    _boardRef.document(entry.documentID).updateData({"isClosed" : true});
  }
  Stream<List<BoardEntry>> getBoardEntriesAsStream(BoardCategory category, int limit){
    Stream<QuerySnapshot> stream = _boardRef
        .where("boardCategoryReference", isEqualTo: category.id)
        .orderBy("lastModifiedDate", descending: true)
        .limit(limit)
        .snapshots();

    return stream.map((snapshot) {
      List<BoardEntry> list = [];
      for (var document in snapshot.documents){
        var entry = BoardEntry.fromJson(document.data, document.documentID);
        list.add(entry);
      }
      return list;
    });
  }
}



/*
  ///Returns a List of all entries of a specific category. The entries are combined with
  ///user information by returning the object [EntryWithUser]. This object will contain
  ///all information from a document in the "Forumeintrag"-Collection and the from a document
  ///in the "User"-Collection.
  Future<List<EntryWithUser>> getBoardEntriesWithUser(
      BoardCategory category) async {
    List<EntryWithUser> list = [];
    await _ref
        .where("boardCategoryReference", isEqualTo: category.id)
        //.limit(length)
        //.orderBy("postingDate", descending: true)
        .getDocuments()
        .then((snapshot) async {
      for (var document in snapshot.documents) {
        var entry = BoardEntry.fromJson(document.data, document.documentID);
        var user = await _userService.getUser(entry.userReference);
        list.add(EntryWithUser(entry: entry, user: user));
      }
    }).timeout(_timeout, onTimeout: () {
      print(
          "Developermessage ERROR: timeout on Service: [BoardEntryService] in: [getBoardEntries()]");
      throw Exception();
    }).catchError((error) {
      print("Developermessage ERROR: " + error);
      throw Exception();
    });
    return list;
  }

   */