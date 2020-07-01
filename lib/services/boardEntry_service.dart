import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/login/models/user_model.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
class EntryWithUser {
  final BoardEntry entry;
  final User user;
  EntryWithUser({@required this.entry, @required this.user});
}

class BoardEntryService extends ChangeNotifier {
  final _timeout = Duration(seconds: 10);
  final CollectionReference _ref =
      Firestore.instance.collection("Forumeintrag");
  final _userService = UserService();

  insertEntry(BoardEntry entry) async {
    await _ref.add(entry.toJson());
  }

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
  ///returns all entries in a category as [EntryWithUser] as list & as stream.
  ///This function provides realtime capabilities to support realtime updates.
  ///set a limit how many entries should load in at once
  Stream<List<EntryWithUser>> getBoardEntriesWithUserAsStream(BoardCategory category, int limit){
    Stream<QuerySnapshot> stream = _ref
        .where("boardCategoryReference", isEqualTo: category.id)
        .orderBy("lastModifiedDate", descending: true)
        .limit(limit)
        .snapshots();

    return stream.asyncMap((snapshot) async{
      List<EntryWithUser> list = [];
      for (var document in snapshot.documents){
        var entry = BoardEntry.fromJson(document.data, document.documentID);
        var user = await _userService.getUser(entry.userReference); //BAD
        list.add(EntryWithUser(entry: entry, user: user));
      }
      return list;
    });
  }
}