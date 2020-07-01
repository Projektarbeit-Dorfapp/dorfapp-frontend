import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageTextField.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class BoardMessagePage extends StatelessWidget {
  final BoardCategory category;
  final BoardEntry entry;
  BoardMessagePage({@required this.category, @required this.entry});

  final messageService = BoardMessageService();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardMessageHandler(entry, category),
      child: Scaffold(
          appBar: AppBar(),
          body: Container(
            color: const Color(0xfff0f0f0),
            child: Stack(
              children: <Widget>[
                StreamBuilder<List<BoardMessageWithUser>>(
                  stream: messageService
                      .getBoardMessagesWithUserAsStream(
                      category, entry, 10, OrderType.latest),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == snapshot.data.length) {
                            return Container(height: 50);
                          }
                          return BoardMessageDisplay(snapshot.data[index]);
                        },
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: const CircularProgressIndicator(),
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

                              },
                              child: const Text("Wiederholen"),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: BoardMessageTextField(),
                ),
              ],
            ),
          )),
    );
  }
}
