import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'alert_service.dart';

///Matthias Maxelon
enum SubscriptionType { news, entry }

class SubscriptionService {
  ///Returns a [Future] bool true if user successfully subscribed, false if already subscribed, null if error occurred.
  ///The Subscription-Document is saved here:
  ///
  ///
  ///-> [TopLevelCollection] -> [topLevelDocumentID] -> [CollectionNames.PIN] -> subscription document.
  ///This document contains no values. The DocumentID is the [User.uid] from [User].
  ///
  ///The creator of the [topLevelDocumentID] will be notified when user subscribes
  Future<bool> subscribe(
      {@required User loggedUser,
      @required String topLevelDocumentID,
      @required SubscriptionType subscriptionType}) async {

    bool isInsert;

    var ref = _getRef(topLevelDocumentID, _getCollectionName(subscriptionType));

    bool isSubscribed = await isUserSubscribed(subscriptionType: subscriptionType, loggedUser: loggedUser, topLevelDocumentID: topLevelDocumentID);
    if (isSubscribed) {
      isInsert = false;
    } else {
      ///Insert subscription

      isInsert = await _insertSubscription(loggedUser, ref);
      if (isInsert){
        _createDuplicate(loggedUser, topLevelDocumentID, subscriptionType);
        _notifyCreator(topLevelDocumentID, loggedUser, subscriptionType);
      }
    }
    return isInsert;
  }

  String _getCollectionName(SubscriptionType type){
    if(type == SubscriptionType.news)
      return CollectionNames.EVENT;

    return CollectionNames.BOARD_ENTRY;

  }

  ///Notify creator of [topLevelDocumentID] that somebody subscribed to his content.
  _notifyCreator(String topLevelDocumentID, User loggedUser, SubscriptionType type) async{
    DocumentSnapshot snapshot = await Firestore.instance.collection(_getCollectionName(type)).document(topLevelDocumentID).get();
    String creatorID = snapshot.data["createdBy"];
    String title = snapshot.data["title"];
    if (snapshot.data["createdBy"] == loggedUser.uid) {
      return;
    }
    final _alertService = AlertService();
    List<String> list = [];
    list.add(creatorID);
    final alert = Alert(
      documentReference: topLevelDocumentID,
      additionalMessage: _createAdditionalMessage(title, loggedUser, type),
      alertType: AlertType.pin_notification,
      fromUserName: loggedUser.userName,
      fromLastName: loggedUser.lastName,
      fromFirstName: loggedUser.firstName,
      creationDate: Timestamp.now(),
      headline: title,
    );
    _alertService.insertAlerts(list, alert);
  }

  String _createAdditionalMessage(String headline, User loggedUser, SubscriptionType type) {
    String text = "";
    String title = headline;

    if (title == null || title == "") title = "[MISSING HEADLINE]";

    if (type == SubscriptionType.entry)
      text = "${loggedUser.firstName} ${loggedUser.lastName} folgt jetzt dein Thema: " + title;
    else
      text = "${loggedUser.firstName} ${loggedUser.lastName} folgt jetzt deiner Veranstaltung: " + title;
    return text;
  }

  ///Each successful subscription process will duplicate data
  _createDuplicate(User loggedUser, String topLevelDocumentID, SubscriptionType subscriptionType) {
    _insertDuplicate(loggedUser, topLevelDocumentID, subscriptionType);
  }

  ///Function to duplicate content of subscription.
  ///
  ///
  /// Duplicate data is saved in [CollectionNames.USER] -> user document -> [CollectionNames.PIN] -> duplicate document
  ///
  //This should allow us to have much fast queries if trying to display all pinned content from a specific user.
  _insertDuplicate(User loggedUser, String topLevelDocumentID, SubscriptionType subscriptionType) async {
    final ref = _getRef(loggedUser.documentID, CollectionNames.USER);
    ref.add({
      "SubscriptionType" : subscriptionType.toString().split('.').last,
      "DocumentReference": topLevelDocumentID,
    });
  }

  Future<bool> _insertSubscription(User loggedUser, CollectionReference ref) async {
    bool isInsert;
    await ref.document(loggedUser.uid).setData({}).then((_) {
      isInsert = true;
    }).catchError((onError) {});
    return isInsert;
  }

  ///Check if user already subscribed to [topLevelDocumentID].
  Future<bool> isUserSubscribed({@required User loggedUser, @required String topLevelDocumentID, @required SubscriptionType subscriptionType}) async {
    var ref = _getRef(topLevelDocumentID, _getCollectionName(subscriptionType));
    bool isSubscribed;
    var subscriptionDoc = await ref.where("uid", isEqualTo: loggedUser.uid).getDocuments();
    if (subscriptionDoc.documents.length == 0) {
      isSubscribed = false;
    } else {
      isSubscribed = true;
    }
    return isSubscribed;
  }

  ///Returns a list of [User.uid] that subscribed to [topLevelDocumentID].
  Future<List<String>> getSubscriptions({@required String topLevelDocumentID, @required SubscriptionType subscriptionType}) async {
    var ref = _getRef(topLevelDocumentID, _getCollectionName(subscriptionType));
    List<String> list = [];
    QuerySnapshot snapshot = await ref.getDocuments();
    for (DocumentSnapshot doc in snapshot.documents) {
      list.add(doc.documentID);
    }
    return list;
  }

  ///Deletes a specific subscription from [topLevelDocumentID]
  deleteSubscription({@required User loggedUser, @required String topLevelDocumentID, @required SubscriptionType subscriptionType}) async {
    final collectionName = _getCollectionName(subscriptionType);
    final ref = _getRef(topLevelDocumentID, collectionName);

    ref.document(loggedUser.uid).delete();
    _deleteDuplicate(loggedUser, topLevelDocumentID);
  }

  _deleteDuplicate(User loggedUser, String topLevelDocumentID) async{
    final ref = _getRef(loggedUser.documentID, CollectionNames.USER);

    var querySnapshot = await ref.where("DocumentReference", isEqualTo: topLevelDocumentID).getDocuments();
    for(int i = 0; i<querySnapshot.documents.length; i++){
      ref.document(querySnapshot.documents[i].documentID).delete();
    }
  }

  ///Returns a [Stream]
  Stream<List<DocumentSnapshot>> getPinnedDocumentsAsStream(User loggedUser, int limit, SubscriptionType subscriptionType){
    final refToUser = _getRef(loggedUser.documentID, CollectionNames.USER);

    Stream<QuerySnapshot> stream = refToUser.where("SubscriptionType", isEqualTo: subscriptionType.toString().split(".").last).limit(limit).snapshots();

    return stream.asyncMap((snapshot) async{
      return await _getReferencedDocuments(subscriptionType, snapshot.documents);
    });
  }

  CollectionReference _getRef(documentID, collection) {
    return Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.PIN);
  }

  Future<List<DocumentSnapshot>> _getReferencedDocuments(SubscriptionType subscriptionType, List<DocumentSnapshot> documentSnapshot) async{
    List<DocumentSnapshot> list = [];
    for(var doc in documentSnapshot){
      final refToDocument = Firestore.instance.collection(_getCollectionName(subscriptionType)).document(doc.data["DocumentReference"]);
      DocumentSnapshot snapshot = await refToDocument.get();
      list.add(snapshot);
    }
    return list;
  }

  ///Returns a [Future]
  Future<List<DocumentSnapshot>> getPinnedDocuments(BuildContext context, SubscriptionType subscriptionType, int limit) async{
    final accessHandler = Provider.of<AccessHandler>(context, listen: false);
    User loggedUser = await accessHandler.getUser();
    final refToUser = _getRef(loggedUser.documentID, CollectionNames.USER);

    QuerySnapshot snapshot =  await refToUser.where("SubscriptionType", isEqualTo: subscriptionType.toString().split(".").last).limit(limit).getDocuments();
    return await _getReferencedDocuments(subscriptionType, snapshot.documents);
  }

}
