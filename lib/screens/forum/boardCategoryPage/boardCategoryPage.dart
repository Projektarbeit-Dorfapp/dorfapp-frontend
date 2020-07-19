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
      body: FutureBuilder(
        future: _boardCategoryService.getBoardCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<List<BoardCategory>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return BoardCategoryDisplay(snapshot.data[index]);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                indent: separatorIndent,
                endIndent: separatorIndent,
              ),
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
}
