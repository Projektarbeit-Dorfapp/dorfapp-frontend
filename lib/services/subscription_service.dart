import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/cupertino.dart';

///Matthias Maxelon
enum NotificationType { news, entry }

class SubscriptionService {
  ///Returns a [Future] bool true if user successfully subscribed, false if already subscribed, null if error occurred.
  ///The Subscription-Document is saved here:
  ///
  ///
  ///-> [TopLevelCollection] -> [topLevelDocumentID] -> [CollectionNames.PIN] -> subscription document.
  ///This document contains no values. The DocumentID is the [User.uid] from [User].
  ///
  ///
  ///Additionally you must specify [shouldNotify] to notify the creator that somebody subscribed to his own content.
  ///If true, make sure to also add a [News] or [BoardEntry] object to this function.
  Future<bool> subscribe(
      {@required User loggedUser,
      @required String topLevelDocumentID,
      @required String topLevelCollection,
      News news,
      BoardEntry entry,
      @required shouldNotify}) async {

    _checkError(shouldNotify, news, entry);

    bool isInsert;
    var ref = _getRef(topLevelDocumentID, topLevelCollection);

    bool isSubscribed = await isUserSubscribed(topLevelCollection: topLevelCollection, loggedUser: loggedUser, topLevelDocumentID: topLevelDocumentID);
    if (isSubscribed) {
      isInsert = false;
    } else {
      ///Insert subscription

      isInsert = await _insertSubscription(loggedUser, news, entry, shouldNotify, ref);
      if (isInsert) _createDuplicate(news, entry, loggedUser, topLevelDocumentID);
    }
    return isInsert;
  }

  ///Each successful subscription process will duplicate data
  _createDuplicate(News news, BoardEntry entry, User loggedUser, String topLevelDocumentID) {
    if (news != null || entry != null) _insertDuplicate(loggedUser, news, entry, topLevelDocumentID);
  }

  ///Function to duplicate content of subscription.
  ///
  ///
  /// Duplicate data is saved in [CollectionNames.USER] -> user document -> [CollectionNames.PIN] -> duplicate document
  ///
  //This should allow us to have much fast queries if trying to display all pinned content from a specific user.
  _insertDuplicate(User loggedUser, News news, BoardEntry entry, String topLevelDocumentID) async{
    final ref = _getRef(loggedUser.documentID, CollectionNames.USER);
    if (entry != null){
      entry.originalDocReference = topLevelDocumentID;
      await ref.add(entry.toJson());
    } else if (news != null) {
      //TODO: duplicate for news?
    }
  }

  Future<bool> _insertSubscription(User loggedUser, News news, BoardEntry entry, bool shouldNotify, CollectionReference ref) async {
    bool isInsert;

    await ref.document(loggedUser.uid).setData({}).then((_) {
      isInsert = true;
      _notificationProcess(news, entry, loggedUser, shouldNotify);
    }).catchError((onError) {});
    return isInsert;
  }

  _checkError(bool shouldNotify, News news, BoardEntry entry) {
    if (shouldNotify) {
      if (news != null && entry != null) {
        throw Exception(
            "The Method subscribe() in [SubscriptionService] should not get a [News]-Object and [BoardEntry]-Object at the same time when shouldNotify is true");
      }
    }
  }

  _notificationProcess(News news, BoardEntry entry, User loggedUser, bool shouldNotify) {
    if (shouldNotify) {
      if (news != null)
        _notifyCreator(news.createdBy, news.description, loggedUser, NotificationType.news);
      else if (entry != null) _notifyCreator(entry.userReference, entry.title, loggedUser, NotificationType.entry);
    }
  }

  ///Notify Creator of Content that somebody subscribed to his content (creatorID must be the User that created content!)
  _notifyCreator(String creatorID, String headline, User loggedUser, NotificationType type) {
    if (creatorID == loggedUser.uid) {
      return;
    }
    final _alertService = AlertService();
    List<String> list = [];
    list.add(creatorID);
    final alert = Alert(
      additionalMessage: _createAdditionalMessage(headline, loggedUser, type),
      alertType: AlertType.pin_notification,
      fromUserName: loggedUser.userName,
      fromLastName: loggedUser.lastName,
      fromFirstName: loggedUser.firstName,
      creationDate: Timestamp.fromDate(DateTime.now()),
      headline: headline,
    );
    _alertService.insertAlerts(list, alert);
  }

  String _createAdditionalMessage(String headline, User loggedUser, NotificationType type) {
    String text = "";
    String title = headline;

    if (title == null || title == "") title = "[MISSING HEADLINE]";

    if (type == NotificationType.entry)
      text = "${loggedUser.userName} folgt jetzt dein Thema: " + title;
    else
      text = "${loggedUser.userName} folgt jetzt deiner Veranstaltung: " + title;

    return text;
  }

  ///Check if user already subscribed to [topLevelDocumentID].
  Future<bool> isUserSubscribed({@required User loggedUser, @required String topLevelDocumentID, @required String topLevelCollection}) async {
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    bool isSubscribed;
    var subscriptionDoc = await ref.document(loggedUser.uid).get();
    if (subscriptionDoc.data == null) {
      isSubscribed = false;
    } else {
      isSubscribed = true;
    }
    return isSubscribed;
  }

  ///Returns a list of [User.uid] that subscribed to [topLevelDocumentID].
  Future<List<String>> getSubscriptions({@required String topLevelDocumentID, @required String topLevelCollection}) async {
    var ref = _getRef(topLevelDocumentID, topLevelCollection);
    List<String> list = [];
    QuerySnapshot snapshot = await ref.getDocuments();
    for (DocumentSnapshot doc in snapshot.documents) {
      list.add(doc.documentID);
    }
    return list;
  }

  ///Deletes a specific subscription from [topLevelDocumentID]
  deleteSubscription({@required User loggedUser, @required String topLevelDocumentID, @required String topLevelCollection}) async {
    final ref = _getRef(topLevelDocumentID, topLevelCollection);
    var snapshot = await Firestore.instance.collection(CollectionNames.BOARD_ENTRY).document(topLevelDocumentID).get();
    ref.document(loggedUser.uid).delete();
    _deleteDuplicate(loggedUser, snapshot);
  }

  //TODO: Duplicate is only checking postingdate and userreference. Which is theoretically like a unique key to get the correct document.
  //TODO: Any other duplicated data should have both of these fields available. Otherwise it wont work. Ask project members...
  _deleteDuplicate(User loggedUser, DocumentSnapshot snapshot) async{
    final ref = _getRef(loggedUser.documentID, CollectionNames.USER);

    var querySnapshot = await ref.where("postingDate", isEqualTo: snapshot.data["postingDate"])
        .where("userReference", isEqualTo: snapshot.data["userReference"])
        .getDocuments();
    for(int i = 0; i<querySnapshot.documents.length; i++){
      ref.document(querySnapshot.documents[i].documentID).delete();
    }
  }

  ///Returns all pinned BoardEntries
  Stream<List<BoardEntry>> getPinnedEntries(User loggedUser, int limit){
    final ref = _getRef(loggedUser.documentID, CollectionNames.USER);
    Stream<QuerySnapshot> stream = ref.where("isEntry", isEqualTo: true).limit(limit).snapshots();

    return stream.map((snapshot){
      List<BoardEntry> list = [];
      for (var document in snapshot.documents){
        var entry = BoardEntry.fromJson(document.data, document.documentID);
        list.add(entry);
      }
      return list;
    });
  }

  CollectionReference _getRef(documentID, collection) {
    return Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.PIN);
  }
}
