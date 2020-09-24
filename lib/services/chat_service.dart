import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/collection_names.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';

///Kilian Berthold & Matthias Maxelon
class ChatService {
  ///Kilian Berthold & Matthias Maxelon
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
              uid: doc.data["uid"],
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

  ///Kilian Berthold & Matthias Maxelon
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

  ///Kilian Berthold
  Future<String> createChat(User currentUser, User targetUser) async {
    try {
      var newChatReference = await Firestore.instance
          .collection(CollectionNames.CHAT)
          .add({"isCreatorOnline": true, "isPartnerOnline": false});
      var newChatID = newChatReference.documentID;

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

  ///Kilian Berthold
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
      "unreadMessages": 0,
      "uid": toUser.uid,
    });
  }

  ///Kilian Berthold
  void sendMessage(String chatID, ChatMessage message) async {
    await Firestore.instance
        .collection(CollectionNames.CHAT)
        .document(chatID)
        .collection(CollectionNames.CHAT_MESSAGES)
        .add(message.toJson());
  }

  ///Matthias Maxelon
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

  ///Kilian Berthold
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

  ///Kilian Berthold
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

  ///Matthias Maxelon
  Stream<DocumentSnapshot> chatDocumentStream(String chatID){
    return Firestore.instance.collection(CollectionNames.CHAT).document(chatID).snapshots();
  }

  ///returns "partner" or "creator" which are the defined roles that two [User]s can potentially have when they chat with each other. An empty String means there is no partner defined which happens when
  ///there is no existing [ChatRoom] for the combination or [User]s. This function is returning the role of the [selectedUser] and not the role from the current client. Note: If [selectedUser] is "partner",
  ///then the current client will always be "creator"
  ///Matthias Maxelon
  Future<String> findRoleOfSelectedUser(User selectedUser, String chatID) async{

    ///The ChatRoom might be opened without a chatID (Not existing at that time) which means there is no defined partner role
    if(chatID == null)
      return "";

    try{
      QuerySnapshot snapshot = await Firestore.instance.collection(CollectionNames.USER)
          .document(selectedUser.documentID)
          .collection(CollectionNames.CHATS)
          .where("chatID", isEqualTo: chatID)
          .getDocuments();

      if(snapshot.documents[0] != null){
        return snapshot.documents[0].data["role"];
      } else{
        return "";
      }
    }catch(e){
      print(e);
      return "";
    }
  }
}
