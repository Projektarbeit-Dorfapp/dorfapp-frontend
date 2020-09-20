import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/messageQuantity.dart';
import 'package:dorf_app/services/authentication_service.dart';
///Matthias Maxelon
enum OrderType {latest, oldest, mostLikes,}


class BoardMessageService{
  final CollectionReference _ref = Firestore.instance.collection("Forumeintrag");
  final _auth = Authentication();
  //final _timeout = Duration(seconds: 10);

  insertBoardMessage(BoardMessage message){
    _ref.document(message.boardEntryReference)
        .collection(CollectionNames.COMMENTS)
        .add(message.toJson());
  }

  Stream<List<BoardMessage>> getBoardMessagesAsStream(
      BoardCategory category, BoardEntry entry, int limit, OrderType orderType, MessageQuantity messageQuantity){
    //String orderField = "";

    Stream<QuerySnapshot> stream = _ref.document(entry.documentID)
        .collection(CollectionNames.COMMENTS)
        .where("boardCategoryReference", isEqualTo: category.documentID)
        .orderBy(_getOrderField(orderType), descending: true)
        .limit(limit)
        .snapshots();

    return stream.map((snapshot) {
      List<BoardMessage> list = [];
      for (var document in snapshot.documents){
        var message = BoardMessage.fromJson(document.data, document.documentID);
        list.add(message);
      }
      messageQuantity.setQuantity(list.length);
      return list;
    });
  }

  String _getOrderField(OrderType orderType){
    String orderField = "";
    if(OrderType.latest == orderType){
      orderField = "postingDate";
    } else if (OrderType.oldest == orderType){
      orderField = "postingDate";
    } else {
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