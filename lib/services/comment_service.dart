import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flutter/cupertino.dart';

///Kilian Berthold & Meike Nedwidek & Matthias Maxelon
class CommentService extends ChangeNotifier {
  SubscriptionService _subscriptionService = SubscriptionService();

  ///Kilian Berthold & Meike Nedwidek
  Future<String> insertNewComment(String documentID, String collection, Comment comment, AlertService alertService, SubscriptionType subscriptionType) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    DocumentReference documentReference = await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).add({
      "firstName": comment.user.firstName,
      "lastName": comment.user.lastName,
      "userID": comment.user.uid,
      "content": comment.content,
      "createdAt": comment.createdAt,
      "modifiedAt": comment.modifiedAt,
      "isDeleted": false
    });
    if(subscriptionType == SubscriptionType.entry){
      _setEntryActivityDate(documentID);
    }
    _notifySubscriber(comment, documentID, collection, subscriptionType, alertService);
    _incrementCommentCount(documentID, collection);
    return documentReference.documentID;
  }

  ///Meike Nedwidek
  _setEntryActivityDate(String documentID){
    BoardEntryService service = BoardEntryService();
    service.updateActivityDate(documentID);
  }

  ///Meike Nedwidek
  ///insert commentCount to [documentID] so that the maximum amount of comments can be easily read
  _incrementCommentCount(String documentID, String collection) async{
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    _collectionReference.document(documentID).updateData({"commentCount" : FieldValue.increment(1)});
  }

  ///Matthias Maxelon
  ///notifies every subscriber to [documentID] that a new comment was posted
  _notifySubscriber(Comment comment, String documentID, String collection, SubscriptionType subscriptionType, AlertService alertService) async{
    List<String> subscriber = await _subscriptionService.getSubscriptions(topLevelDocumentID: documentID, subscriptionType: subscriptionType);
    DocumentSnapshot snapshot = await Firestore.instance.collection(collection).document(documentID).get();
    Alert alert = Alert(
      additionalMessage: '${comment.user.firstName} ${comment.user.lastName} hat eine Nachricht in "${snapshot.data["title"]}" verfasst',
      alertType: subscriptionType == SubscriptionType.entry ? AlertType.boardMessage : AlertType.news,
      documentReference: documentID,
      creationDate: comment.createdAt,
      fromFirstName: comment.user.firstName,
      fromLastName: comment.user.lastName,
      fromUserName: comment.user.userName,
    );
    alertService.insertAlerts(subscriber, alert);
  }

  ///Kilian Berthold & Meike Nedwidek
  Future<String> insertAnswerComment(String documentID, String collection, Comment comment, String answerTo, SubscriptionType subscriptionType) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    DocumentReference documentReference = await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(answerTo).collection(CollectionNames.ANSWERS).add({
      "firstName": comment.user.firstName,
      "lastName": comment.user.lastName,
      "userID": comment.user.uid,
      "content": comment.content,
      "createdAt": comment.createdAt,
      "modifiedAt": comment.modifiedAt,
      "isDeleted": false
    });

    if(subscriptionType == SubscriptionType.entry){
      _setEntryActivityDate(documentID);
    }
    _incrementCommentCount(documentID, collection);
    return documentReference.documentID;
  }

  ///Kilian Berthold & Meike Nedwidek
  void updateComment(String documentID, String collection, String newContent, String commentID) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(commentID).updateData({
      "content": newContent,
      "modifiedAt": DateTime.now(),
    });
  }

  ///Kilian Berthold & Meike Nedwidek
  void deleteComment(String documentID, String collection, String commentID) async {
    try{
      CollectionReference _collectionReference = Firestore.instance.collection(collection);
      await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(commentID).updateData({
        "isDeleted": true,
        "modifiedAt": DateTime.now(),
        "content": "Diese Nachricht wurde gelöscht."
      });
    }
    catch(err){
      print(err.toString());
    }
  }

  ///Meike Nedwidek
  void deleteAnswer(String documentID, String collection, String commentID, String topCommentID) async {
    try{
      CollectionReference _collectionReference = Firestore.instance.collection(collection);
      await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(topCommentID).collection(CollectionNames.ANSWERS).document(commentID).updateData({
        "isDeleted": true,
        "modifiedAt": DateTime.now(),
        "content": "Diese Nachricht wurde gelöscht."
      });
    }
    catch(err){
      print(err.toString());
    }
  }

  ///Matthias Maxelon
  Future<int> getCommentQuantity (String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS);
    QuerySnapshot snapshot = await _collectionReference.getDocuments();
    return snapshot.documents.length;
}


  ///Meike Nedwidek
  Future<List<TopComment>> getComments(String documentID, String collection) async {
    List<TopComment> comments = [];
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS);
    QuerySnapshot snapshot = await _collectionReference.orderBy("createdAt", descending: false).getDocuments();
    for(DocumentSnapshot doc in snapshot.documents){
      final comment = Comment(
        firstName: doc.data["firstName"],
        lastName: doc.data["lastName"],
        user: User(
          uid: doc.data["userID"],
          firstName: doc.data["firstName"],
          lastName: doc.data["lastName"],
        ),
        userID: doc.data["userID"],
        content: doc.data["content"],
        createdAt: doc.data["createdAt"],
        modifiedAt: doc.data["modifiedAt"],
        id: doc.documentID,
        isDeleted: doc.data["isDeleted"],
      );

      List<Comment> answerList = await getAnswers(comment.id, collection, documentID);
      comments.add(TopComment(comment, answerList));
    }
    return comments;
  }

  ///Meike Nedwidek
  Future<List<Comment>> getAnswers(String topCommentId, String collection, String documentID) async {
    List<Comment> answerList = [];
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS).document(topCommentId).collection(CollectionNames.ANSWERS);
    QuerySnapshot snapshot = await _collectionReference.orderBy("createdAt", descending: false).getDocuments();
    for(DocumentSnapshot doc in snapshot.documents){
      final comment = Comment(
        firstName: doc.data["firstName"],
        lastName: doc.data["lastName"],
        user: User(
          uid: doc.data["userID"],
          firstName: doc.data["firstName"],
          lastName: doc.data["lastName"],
        ),
        userID: doc.data["userID"],
        content: doc.data["content"],
        createdAt: doc.data["createdAt"],
        modifiedAt: doc.data["modifiedAt"],
        id: doc.documentID,
        isDeleted: doc.data["isDeleted"],
      );

      answerList.add(comment);
    }
    return answerList;
  }

}