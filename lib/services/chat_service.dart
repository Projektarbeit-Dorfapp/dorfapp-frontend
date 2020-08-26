import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/user_service.dart';

///Kilian Berthold
class ChatService {
  Future<List<OpenChat>> getOpenConnections(String userID) async {
    CollectionReference _chatroomsCollectionReference =
        Firestore.instance.collection(CollectionNames.USER).document(userID).collection(CollectionNames.CHATS);
    List<OpenChat> openChats = [];
    try {
      QuerySnapshot snapshot = await _chatroomsCollectionReference.getDocuments();
      for (DocumentSnapshot doc in snapshot.documents) {
        final openChat = OpenChat(
          chatID: doc.data["chatID"],
          user: User(
            uid: doc.documentID,
            userName: doc.data["userName"],
            firstName: doc.data["firstName"],
            lastName: doc.data["lastName"],
          ),
        );
        openChats.add(openChat);
      }
    } catch (err) {
      print(err.toString());
    }

    return openChats;
  }

  Future<List<ChatMessage>> getMessages(String chatID) async {
    CollectionReference _chatMessagesCollectionReference =
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).collection(CollectionNames.CHAT_MESSAGES);
    List<ChatMessage> chatMessages = [];
    try {
      QuerySnapshot snapshot =
          await _chatMessagesCollectionReference.orderBy("createdAt", descending: true).getDocuments();
      for (DocumentSnapshot doc in snapshot.documents) {
        final openChat = ChatMessage(
            messageFrom: doc.data["messageFrom"], message: doc.data["message"], createdAt: doc.data["createdAt"]);
        chatMessages.add(openChat);
      }
    } catch (err) {
      print(err.toString());
    }
    return chatMessages;
  }

  Future<String> createChat(User currentUser, String targetUserUID) async {
    var _userService = UserService();

    try {
      var newChatReference = await Firestore.instance.collection(CollectionNames.CHAT).add({});
      var newChatID = newChatReference.documentID;

      ///TODO Kann eventuell zu "(await Firestore.instance.collection(CollectionNames.CHAT).add({})).documentID" verkürzt werden, testen.

      CollectionReference _userCollectionReference = Firestore.instance.collection(CollectionNames.USER);

      ///Get Info of Target User
      var targetUser = await _userService.getUser(targetUserUID);

      ///Add new Chat to logged in user
      await addNewChatToUser(_userCollectionReference, newChatID, currentUser, targetUser);

      ///Add new Chat to targeted user
      await addNewChatToUser(_userCollectionReference, newChatID, targetUser, currentUser);

      return newChatID;
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<void> addNewChatToUser(
      CollectionReference _userCollectionReference, String newChatID, User fromUser, User toUser) async {
    await _userCollectionReference
        .document(fromUser.documentID)
        .collection(CollectionNames.CHATS)
        .document(toUser.documentID)
        .setData({
      "chatID": newChatID,
      "firstName": toUser.firstName,
      "lastName": toUser.lastName,
      "userName": toUser.userName
    });
  }

  void sendMessage(String chatID, ChatMessage message) async {
    await Firestore.instance
        .collection(CollectionNames.CHAT)
        .document(chatID)
        .collection(CollectionNames.CHAT_MESSAGES)
        .add(message.toJson());
  }
}
