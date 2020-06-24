import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/addEntryPage.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/boardEntryDisplay.dart';
import 'package:dorf_app/services/boardEntry_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardEntryPage extends StatefulWidget {
  @override
  _BoardEntryPageState createState() => _BoardEntryPageState();
}

class _BoardEntryPageState extends State<BoardEntryPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entryService = Provider.of<BoardEntryService>(context, listen: false);
    final BoardCategory category = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(category.title),
      ),
      body: Container(
        color: Color(0xfff0f0f0),
        child: Stack(
          children: <Widget>[
            FutureBuilder<List<EntryWithUser>>(
              future: entryService.getBoardEntriesWithUserByCategory(category),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == snapshot.data.length){
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                        );
                      }
                      _controller.forward();
                      return FadeScaleTransition(
                        animation: _controller,
                        child: BoardEntryDisplay(
                          category: category,
                          entryWithUser: snapshot.data[index],
                        ),
                      );
                    },
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else { ///ERROR
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Etwas ist schief gelaufen :("),
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
            ),
            ///BUTTON TO ADDENTRYPAGE
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(

                  width: 60,
                  height: 60,
                  child: OpenContainer(
                    onClosed: (_) {
                      setState(() {});
                    },
                    closedColor: Colors.lightGreen,
                    closedElevation: 10.0,
                    openElevation: 15.0,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    transitionType: ContainerTransitionType.fade,
                    transitionDuration: const Duration(milliseconds: 450),
                    openBuilder: (context, action) {
                      return AddEntryPage(
                        category: category,
                      );
                    },
                    closedBuilder: (context, action) {
                      return Container(
                          child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
