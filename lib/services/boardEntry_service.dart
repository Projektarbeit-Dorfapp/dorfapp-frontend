import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';


///Matthias Maxelon
class BoardEntryService{
  final CollectionReference _boardRef = Firestore.instance.collection(CollectionNames.BOARD_ENTRY);

  Future<DocumentReference> insertEntry(BoardEntry entry) async {
    return await _boardRef.add(entry.toJson());
  }

  Future<BoardEntry> getEntry(String entryID) async{
    final snapshot = await _boardRef.document(entryID).get();
    if(snapshot.data != null){
      return BoardEntry.fromJson(snapshot.data, snapshot.documentID);
    } else {
      return null;
    }
  }

  updateActivityDate(String documentID){
    _boardRef.document(documentID).updateData({"lastActivity" : Timestamp.now()});
  }

  incrementWatchCount(BoardEntry entry){
    Future.delayed(Duration(milliseconds: 300)).then((_){
      _boardRef.document(entry.documentID).updateData({"watchCount" : FieldValue.increment(1)});
    });
  }

  closeBoardEntry(BoardEntry entry){
    _boardRef.document(entry.documentID).updateData({"isClosed" : true});
  }

  Stream<List<BoardEntry>> getBoardEntriesAsStream(BoardCategory category, int limit){
    Stream<QuerySnapshot> stream = _boardRef
        .where("boardCategoryReference", isEqualTo: category.documentID)
        .orderBy("lastActivity", descending: true)
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