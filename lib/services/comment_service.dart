import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/alert_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/topComment_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/services/subscription_service.dart';

class CommentService {
  SubscriptionService _subscriptionService = SubscriptionService();

  void insertNewComment(String documentID, String collection, Comment comment, AlertService alertService, SubscriptionType subscriptionType) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).add({
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
  }

  _setEntryActivityDate(String documentID){
    BoardEntryService service = BoardEntryService();
    service.updateActivityDate(documentID);
  }

  ///insert commentCount to [documentID] so that the maximum amount of comments can be easily read
  _incrementCommentCount(String documentID, String collection) async{
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    _collectionReference.document(documentID).updateData({"commentCount" : FieldValue.increment(1)});
  }

  ///notifies every subscriber to [documentID] that a new comment was posted
  _notifySubscriber(Comment comment, String documentID, String collection, SubscriptionType subscriptionType, AlertService alertService) async{
    List<String> subscriber = await _subscriptionService.getSubscriptions(topLevelDocumentID: documentID, subscriptionType: subscriptionType);
    DocumentSnapshot snapshot = await Firestore.instance.collection(collection).document(documentID).get();
    Alert alert = Alert(
      additionalMessage: 'Der Benutzer ${comment.user.firstName} ${comment.user.lastName} hat eine Nachricht in "${snapshot.data["title"]}" verfasst',
      alertType: subscriptionType == SubscriptionType.entry ? AlertType.boardMessage : AlertType.eventMessage,
      documentReference: documentID,
      creationDate: comment.createdAt,
      fromFirstName: comment.user.firstName,
      fromLastName: comment.user.lastName,
      fromUserName: comment.user.userName,
    );
    alertService.insertAlerts(subscriber, alert);
  }

  void insertAnswerComment(String documentID, String collection, Comment comment, String answerTo) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(answerTo).collection(CollectionNames.ANSWERS).add({
      "firstName": comment.user.firstName,
      "lastName": comment.user.lastName,
      "userID": comment.user.uid,
      "content": comment.content,
      "createdAt": comment.createdAt,
      "modifiedAt": comment.modifiedAt,
      "isDeleted": false
    });
  }

  void updateComment(String documentID, String collection, String newContent, String commentID) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(commentID).updateData({
      "content": newContent,
      "modifiedAt": DateTime.now(),
    });
  }

  void deleteComment(String documentID, String collection, String commentID) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection(CollectionNames.COMMENTS).document(commentID).updateData({
      "firstName": "",
      "lastName": "",
      "userID": "",
      "isDeleted": true,
      "modifiedAt": DateTime.now(),
      "content": "Diese Nachricht wurde gelöscht."
    });
  }
  Future<int> getCommentQuantity (String documentID, String collection) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS);
    QuerySnapshot snapshot = await _collectionReference.getDocuments();
    return snapshot.documents.length;
}


  //Ich brauche die Kommentarliste um das CommentSection Widget mit Daten zu befüllen. Meike zieht das aus dem newsModel raus. Im Forum hab ich hier
  //eine ganz andere Umgebung. Deshalb muss ich die Kommentare mit der function hier holen. Wenns eine andere Möglichkeit gibt, bitte bescheid geben - Matthias
  Future<List<TopComment>> getComments(String documentID, String collection) async {
    List<TopComment> comments = [];
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS);
    QuerySnapshot snapshot = await _collectionReference.getDocuments();
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

  Future<List<Comment>> getAnswers(String topCommentId, String collection, String documentID) async {
    List<Comment> answerList = [];
    CollectionReference _collectionReference = Firestore.instance.collection(collection).document(documentID).collection(CollectionNames.COMMENTS).document(topCommentId).collection(CollectionNames.ANSWERS);
    QuerySnapshot snapshot = await _collectionReference.getDocuments();
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