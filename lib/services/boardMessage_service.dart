import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum OrderType {latest, oldest, mostLikes,}

class BoardMessageWithUser{
  BoardMessage message;
  User user;
  BoardMessageWithUser({this.message, this.user});
}
class BoardMessageService{
  final CollectionReference _ref = Firestore.instance.collection("Forumeintrag");
  final _userService = UserService();
  final _auth = Authentication();
  //final _timeout = Duration(seconds: 10);

  insertBoardMessage(BoardMessage message){
    _ref.document(message.boardEntryReference)
        .collection("Forumbeitrag")
        .add(message.toJson());
  }

  Stream<List<BoardMessageWithUser>> getBoardMessagesWithUserAsStream(
      BoardCategory category, BoardEntry entry, int limit, OrderType orderType){
    String orderField = "";

    Stream<QuerySnapshot> stream = _ref.document(entry.id)
        .collection("Forumbeitrag")
        .where("boardCategoryReference", isEqualTo: category.id)
        .orderBy(_getOrderField(orderType), descending: true)
        .limit(limit)
        .snapshots();

    return stream.asyncMap((snapshot) async{
      List<BoardMessageWithUser> list = [];
      for (var document in snapshot.documents){
        var message = BoardMessage.fromJson(document.data, document.documentID);
        var user = await _userService.getUser(message.userReference);
        list.add(BoardMessageWithUser(message: message, user: user));
      }
      return list;
    });
  }
  //TODO: INTO LIKE SERVICE FROM MEIKE??
  Future<bool> insertBoardMessageLike(BoardMessage message) async{
    var likeRef = await _getLikeRef(message);
    if(await isLiked(message)){
      await likeRef.delete();
      return false;
    } else{
      await likeRef.setData({});
      return true;
    }
  }
  //TODO: INTO LIKE SERVICE FROM MEIKE??
  Future<bool> isLiked(BoardMessage message) async{

    var likeRef = await _getLikeRef(message);
    try{
      DocumentSnapshot snapshot = await likeRef.get();
      if(snapshot.exists)
        return true;
      else
        return false;
    } catch(error){
      print(error);
      return true; //TODO: SHOULD IT SIMPLY RETURN TRUE SO NOTHING HAPPENS WHEN ERROR OCCURES??
    }
  }
  //TODO: INTO LIKE SERVICE FROM MEIKE??
  Future<DocumentReference> _getLikeRef(BoardMessage message) async{
    FirebaseUser user = await _auth.getCurrentUser();
    return _ref.document(message.boardEntryReference)
        .collection("Forumbeitrag")
        .document(message.id)
        .collection("Likes")
        .document(user.uid);
  }
  //TODO: INTO MEIKES LIKE SERVICE???
  Future<List<dynamic>> getLikesAndIsLikedCheck(BoardMessage message) async{
    List<dynamic> likeWithUserCheckList = [];
    var user = await _auth.getCurrentUser();
    await _ref.document(message.boardEntryReference)
          .collection("Forumbeitrag")
          .document(message.id)
          .collection("Likes")
          .getDocuments()
          .then((snapshot){
            likeWithUserCheckList.add(snapshot.documents.length);
            for(var document in snapshot.documents){
              if(document.documentID == user.uid){
                likeWithUserCheckList.add(true);
              }
            }
            if(likeWithUserCheckList.contains(true))
              return;
            else likeWithUserCheckList.add(false);
        }).catchError((onError){
          print(onError);
        });
      return likeWithUserCheckList;
  }
  String _getOrderField(OrderType orderType){
    String orderField = "";
    if(OrderType.latest == orderType){
      orderField = "postingDate";
    } else if (OrderType.oldest == orderType){
      orderField = "postingDate";
    } else {
      //TODO: ORDER BY COMMENTS WITH MOST LIKES
    }
    return orderField;
  }











/*
  Future<List<BoardMessageWithUser>> getBoardMessagesWithUser(BoardCategory category, BoardEntry entry) async{
    List<BoardMessageWithUser> list = [];
    await _ref
        .where("boardCategoryReference", isEqualTo: category.id)
        .where("boardEntryReference", isEqualTo: entry.id)
        //.limit(length)
        .getDocuments()
        .then((snapshot) async{
          for(var document in snapshot.documents) {
            var message = BoardMessage.fromJson(document.data, document.documentID);
            var user = await _userService.getUser(message.userReference);
            list.add(BoardMessageWithUser(message: message, user: user));
          }
        })
        .timeout(_timeout, onTimeout: (){
          print("Developermessage ERROR: timeout on Service: [BoardMessageService] in: [getBoardMessagesWithUser()]");
          throw Exception();
        })
        .catchError((error){
          print("Developermessage ERROR: " + error);
          throw Exception();
        });
    return list;
  }

   */
}