import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/comment_model.dart';

class CommentService {

  void insertNewComment(String documentID, String collection, Comment comment) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("comments").add({
      "firstName": comment.user.firstName,
      "lastName": comment.user.lastName,
      "userID": comment.user.uid,
      "content": comment.content,
      "createdAt": comment.createdAt,
      "modifiedAt": comment.modifiedAt,
      "isDeleted": false
    });
  }

  void insertAnswerComment(String documentID, String collection, Comment comment) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("comments").add({
      "firstName": comment.user.firstName,
      "lastName": comment.user.lastName,
      "userID": comment.user.uid,
      "content": comment.content,
      "answerTo": comment.answerTo,
      "createdAt": comment.createdAt,
      "modifiedAt": comment.modifiedAt,
      "isDeleted": false
    });
  }

  void updateComment(String documentID, String collection, String newContent, String commentID) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("comments").document(commentID).updateData({
      "content": newContent,
      "modifiedAt": DateTime.now(),
    });
  }

  void deleteComment(String documentID, String collection, String commentID) async {
    CollectionReference _collectionReference = Firestore.instance.collection(collection);
    await _collectionReference.document(documentID).collection("comments").document(commentID).updateData({
      "firstName": "",
      "lastName": "",
      "userID": "",
      "isDeleted": true,
      "modifiedAt": DateTime.now(),
      "content": "Diese Nachricht wurde gelöscht."
    });
  }
}