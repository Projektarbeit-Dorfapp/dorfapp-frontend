import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/user_service.dart';

///Kilian Berthold & Matthias Maxelon
class ChatService {
  Stream<List<OpenChat>> getOpenConnectionsAsStream(User user) {
    CollectionReference _chatroomsCollectionReference =
        Firestore.instance.collection(CollectionNames.USER).document(user.documentID).collection(CollectionNames.CHATS);

    Stream stream = _chatroomsCollectionReference.snapshots();

    return stream.map((snapshot) {
      List<OpenChat> openChats = [];
      for (DocumentSnapshot doc in snapshot.documents) {
        final openChat = OpenChat(
            chatID: doc.data["chatID"],
            role: doc.data["role"],
            unreadMessages: doc.data["unreadMessages"],
            user: User(
              documentID: doc.documentID,
              userName: doc.data["userName"],
              firstName: doc.data["firstName"],
              lastName: doc.data["lastName"],
            ));
        openChats.add(openChat);
      }
      return openChats;
    });
  }

  Stream<List<ChatMessage>> getMessages(String chatID) {
    CollectionReference _chatMessagesCollectionReference =
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).collection(CollectionNames.CHAT_MESSAGES);

    Stream stream = _chatMessagesCollectionReference.orderBy("createdAt", descending: true).snapshots();
    return stream.map((snapshot) {
      List<ChatMessage> chatMessages = [];
      for (var document in snapshot.documents) {
        var entry = ChatMessage.fromJson(document.data, document.documentID);
        chatMessages.add(entry);
      }
      return chatMessages;
    });
  }

  Future<String> createChat(User currentUser, User targetUser) async {
    try {
      var newChatReference = await Firestore.instance
          .collection(CollectionNames.CHAT)
          .add({"isCreatorOnline": true, "isPartnerOnline": false});
      var newChatID = newChatReference.documentID;

      ///TODO Kann eventuell zu "(await Firestore.instance.collection(CollectionNames.CHAT).add({})).documentID" verkürzt werden, testen.

      CollectionReference _userCollectionReference = Firestore.instance.collection(CollectionNames.USER);

      ///Add new Chat to logged in user (Creator)
      await addNewChatToUser(_userCollectionReference, newChatID, currentUser, targetUser, "creator");

      ///Add new Chat to targeted user (Partner)
      await addNewChatToUser(_userCollectionReference, newChatID, targetUser, currentUser, "partner");

      return newChatID;
    } catch (err) {
      print(err.toString());
    }
    return null;
  }

  Future<void> addNewChatToUser(
      CollectionReference _userCollectionReference, String newChatID, User fromUser, User toUser, String role) async {
    await _userCollectionReference
        .document(fromUser.documentID)
        .collection(CollectionNames.CHATS)
        .document(toUser.documentID)
        .setData({
      "chatID": newChatID,
      "firstName": toUser.firstName,
      "lastName": toUser.lastName,
      "userName": toUser.userName,
      "role": role,
      "unreadMessages": 0
    });
  }

  void sendMessage(String chatID, ChatMessage message) async {
    await Firestore.instance
        .collection(CollectionNames.CHAT)
        .document(chatID)
        .collection(CollectionNames.CHAT_MESSAGES)
        .add(message.toJson());
  }

  Future<String> getChatRoomID(User loggedUser, User selectedUser) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection(CollectionNames.USER)
        .document(loggedUser.documentID)
        .collection(CollectionNames.CHATS)
        .where("userName", isEqualTo: selectedUser.userName)
        .getDocuments();

    if (snapshot.documents.length != 0) {
      return snapshot.documents[0].data["chatID"].toString();
    } else
      return "";
  }

  void goOnline(User loggedUser, User selectedUser, String chatID, String role) {
    Firestore.instance
        .collection(CollectionNames.USER)
        .document(loggedUser.documentID)
        .collection(CollectionNames.CHATS)
        .document(selectedUser.documentID)
        .updateData({"unreadMessages": 0});

    switch (role) {
      case "partner":
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).updateData({"isPartnerOnline": true});
        break;
      case "creator":
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).updateData({"isCreatorOnline": true});
        break;
      default:
        break;
    }
  }

  void goOffline(User loggedUser, User selectedUser, String chatID, String role) {
    switch (role) {
      case "partner":
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).updateData({"isPartnerOnline": false});
        break;
      case "creator":
        Firestore.instance.collection(CollectionNames.CHAT).document(chatID).updateData({"isCreatorOnline": false});
        break;
      default:
        break;
    }
  }

  ///Matthias
  Stream<DocumentSnapshot> chatDocumentStream(String chatID){
    return Firestore.instance.collection(CollectionNames.CHAT).document(chatID).snapshots();
  }
}
