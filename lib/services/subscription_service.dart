import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/cupertino.dart';

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
  ///
  ///Additionally you must specify [shouldNotify] to notify the creator that somebody subscribed to his own content.
  ///If true, make sure to also add a [News] or [BoardEntry] object to this function.
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
      if (isInsert) _createDuplicate(loggedUser, topLevelDocumentID, subscriptionType);
    }
    return isInsert;
  }
  String _getCollectionName(SubscriptionType type){
    if(type == SubscriptionType.news)
      return CollectionNames.EVENT;

    return CollectionNames.BOARD_ENTRY;

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
    print(loggedUser);
    print("UUUUUUUUUUUUUUU fucking ID");
    print(loggedUser.uid);
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

    //var snapshot = await Firestore.instance.collection(collectionName).document(topLevelDocumentID).get();
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
