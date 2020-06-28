import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/provider/boardMessageHandler.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageTextField.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class BoardMessagePage extends StatefulWidget {
  final BoardCategory category;
  final BoardEntry entry;
  BoardMessagePage({@required this.category, @required this.entry});
  @override
  _BoardMessagePageState createState() => _BoardMessagePageState();
}

class _BoardMessagePageState extends State<BoardMessagePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardMessageHandler(widget.entry, widget.category),
      child: Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: <Widget>[
              Consumer<BoardMessageHandler>(
                builder: (context, messageHandler, _){
                  return StreamBuilder<List<BoardMessageWithUser>>(
                    stream: BoardMessageService().getBoardMessagesWithUserAsStream(widget.category, widget.entry, 10, OrderType.latest),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (BuildContext context, int index){
                            if(index == snapshot.data.length){
                              return Container(height: 50);
                            }
                            return BoardMessageDisplay(snapshot.data[index]);
                          },
                        );
                      } else if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else { ///ERROR
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Etwas ist schief gelaufen"),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                child: Text("Wiederholen"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: BoardMessageTextField(
                ),
              ),
            ],
          )
      ),
    );
  }
}