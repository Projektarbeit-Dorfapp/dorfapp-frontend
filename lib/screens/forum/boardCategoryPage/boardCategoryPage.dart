import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/boardCategoryPage/widgets/boardCategoryDisplay.dart';
import 'package:dorf_app/services/boardCategory_service.dart';
import 'package:flutter/material.dart';


class BoardCategoryPage extends StatelessWidget {
  final _boardCategoryService = BoardCategoryService();
  @override
  Widget build(BuildContext context) {
    final separatorIndent = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      body: FutureBuilder(
        future: _boardCategoryService.getBoardCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BoardCategory>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index){
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: BoardCategoryDisplay(
                        snapshot.data[index], _getColor(index, context)),
                  ),
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            ///ERROR
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Etwas ist schief gelaufen :("),
                  RaisedButton(
                    onPressed: () {
                      //TODO: NEED TO REFRESH
                    },
                    child: Text("Wiederholen"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  //idk
  Color _getColor(int index, BuildContext context){
    if(index == 1)
      return Color(0xff6178A3);
    else if (index == 0)
      return Color(0xff70a1a0);
    else if (index == 2)
      return Theme.of(context).buttonColor;
    else if(index == 3)
      return Color(0xff916740);
    else return Colors.deepPurple;
  }
}
