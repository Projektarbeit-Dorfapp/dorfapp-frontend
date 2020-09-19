import 'dart:async';

import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class MessageStream extends StatefulWidget {
  final User loggedUser;
  final String chatID;
  MessageStream(this.loggedUser, this.chatID);
  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 1);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<ChatMessage>>(
              stream: _getMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, int index) {
                      return Align(
                        alignment: snapshot.data[index].messageFrom == widget.loggedUser.uid ? Alignment.centerRight : Alignment.centerLeft,
                        child: ChatRoomMessage(
                          loggedUser: widget.loggedUser,
                          messageInfo: snapshot.data[index],
                        ),
                      );
                    },
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
    );
  }

  Stream<List<ChatMessage>> _getMessages() {
    final chatS = ChatService();
    return chatS.getMessages(widget.chatID);
  }
}

class ChatRoomMessage extends StatelessWidget {
  final ChatMessage messageInfo;
  final User loggedUser;
  ChatRoomMessage({@required this.messageInfo, @required this.loggedUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4, left: 20, right: 20),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: messageInfo.messageFrom == loggedUser.uid
                    ? BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))
                    : BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
                color: messageInfo.messageFrom == loggedUser.uid ? Theme.of(context).primaryColor : Color(0xFFE6E6E6)),
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 50, bottom: 15, top: 10),
              child: Text(
                messageInfo.message,
                style: TextStyle(color: messageInfo.messageFrom == loggedUser.uid ? Colors.white : Colors.black, fontSize: 16),
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: RelativeDate(DateTime.fromMicrosecondsSinceEpoch(messageInfo.createdAt.microsecondsSinceEpoch),
                messageInfo.messageFrom == loggedUser.uid ? Colors.white70 : Colors.black54, 9),
          ),
        ],
      ),
    );
  }
}
