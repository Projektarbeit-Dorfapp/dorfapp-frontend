import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';

import 'package:flutter/material.dart';

class MessageStream extends StatefulWidget {
  final User loggedUser;
  MessageStream(this.loggedUser);
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  ScrollController _scrollController;
  
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getMessages(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          /*
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );

           */
          List<ChatMessage> messages = _parseSnapshotToChatMessage(snapshot);
          return ListView.builder(
           controller: _scrollController,
           itemCount: messages.length,
           itemBuilder: (context, int index){

             return Align(
               alignment: messages[index].messageFrom == widget.loggedUser.uid ? Alignment.centerRight : Alignment.centerLeft,
               child: ChatRoomMessage(
                 loggedUser: widget.loggedUser,
                 messageInfo: messages[index],),
             );
           }, 
          );
        } else if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else 
          return const Center(
            child: CircularProgressIndicator(),
        );
      },
    );
  }
  
  //TODO: fetch from chatservice
  Stream<QuerySnapshot> _getMessages(){

  }
  
  List<ChatMessage> _parseSnapshotToChatMessage(AsyncSnapshot<QuerySnapshot> snapshot){
    List<ChatMessage> list = [];
    for(var document in snapshot.data.documents){
      list.add(ChatMessage.fromJson(document.data, document.documentID));
    }
    return list;
  }
}

class ChatRoomMessage extends StatelessWidget {
  final ChatMessage messageInfo;
  final User loggedUser;
  ChatRoomMessage({@required this.messageInfo, @required this.loggedUser});
  
  @override
  Widget build(BuildContext context) {
    double halfSize = MediaQuery.of(context).size.width * 0.5;
    return Container(
      width: halfSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: messageInfo.messageFrom == loggedUser.uid ? Theme.of(context).primaryColor : Color(0xFFE6E6E6)

      ),
      child: Text(messageInfo.message, style: TextStyle(
        color: messageInfo.messageFrom == loggedUser.uid ? Colors.white : Colors.black
      ),),
    );
  }
}

