import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/screens/login/models/user_model.dart';
import 'package:dorf_app/services/user_service.dart';

class BoardMessageWithUser{
  BoardMessage message;
  User user;
  BoardMessageWithUser({this.message, this.user});
}
class BoardMessageService{
  final CollectionReference _ref = Firestore.instance.collection("Forumbeitrag");
  final _userService = UserService();
  final _timeout = Duration(seconds: 10);

  insertBoardMessage(BoardMessage message){
    _ref.add(message.toJson());
  }

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
}