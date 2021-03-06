import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/messageQuantity.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageDisplay.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class NotUsed extends StatefulWidget {
  final BoardCategory category;
  final BoardEntry entry;

  const NotUsed({@required this.category, @required this.entry,});
  @override
  _NotUsedState createState() => _NotUsedState();
}

class _NotUsedState extends State<NotUsed> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ScrollController _scrollController;
  MessageQuantity _messageQuantity;
  int _listSizeLimit = 15;
  BoardMessageService _messageService;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_increaseListSize);
    _messageService = BoardMessageService();
    _messageQuantity = Provider.of<MessageQuantity>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BoardMessage>>(
      stream: _messageService.getBoardMessagesAsStream(
          widget.category,
          widget.entry,
          _listSizeLimit,
          OrderType.latest,
          _messageQuantity),
      builder: (context, snapshot) {
        if (snapshot.hasData) {

          return Container(
            height: 300,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data.length) {
                  return Container(height: 50);
                }
                _animationController.forward();
                return FadeScaleTransition(
                  animation: _animationController,
                  child: BoardMessageDisplay(snapshot.data[index], widget.entry.createdBy),
                );
              },
            ),
          );
        } else if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
           //child: const CircularProgressIndicator(),
          );
        } else {
          ///ERROR
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Etwas ist schief gelaufen"),
                RaisedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text("Wiederholen"),
                ),
              ],
            ),
          );
        }
      },
    );
  }
  _increaseListSize() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _listSizeLimit = _listSizeLimit + 10;
      });
    }
  }
}
