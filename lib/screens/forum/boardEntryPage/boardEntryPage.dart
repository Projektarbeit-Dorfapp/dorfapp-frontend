import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/forum/boardCategoryPage/widgets/boardCategoryDisplay.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/addEntryNavigationButton.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/boardEntryDisplay.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:flutter/material.dart';

class BoardEntryPage extends StatefulWidget {
  @override
  _BoardEntryPageState createState() => _BoardEntryPageState();
}

class _BoardEntryPageState extends State<BoardEntryPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  ScrollController _scrollController;
  int _listSizeLimit = 10;
  final _boardEntryService = BoardEntryService();
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _scrollController = ScrollController();
    _scrollController.addListener(_increaseListSize);
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
    final CategoryWithColor categoryWithColor = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: categoryWithColor.categoryColor,
        centerTitle: true,
        title: Text(categoryWithColor.category.title),
      ),
      body: Container(
        color: Color(0xfff0f0f0),
        child: Stack(
          children: <Widget>[
            StreamBuilder<List<BoardEntry>>(
              stream: _boardEntryService.getBoardEntriesAsStream(categoryWithColor.category, _listSizeLimit),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {

                      if(index == snapshot.data.length){
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                        );
                      }
                      _animationController.forward();
                      return FadeScaleTransition(
                        animation: _animationController,
                        child: BoardEntryDisplay(
                          //categoryColor: categoryWithColor.categoryColor,
                          boardCategoryReference: categoryWithColor.category.documentID,
                          entry: snapshot.data[index],
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
            AddEntryNavigationButton(category: categoryWithColor.category, categoryColor: categoryWithColor.categoryColor,)
          ],
        ),
      ),
    );
  }
  _increaseListSize(){
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
     setState(() {
       _listSizeLimit = _listSizeLimit + 10;
     });
    }
  }
}
