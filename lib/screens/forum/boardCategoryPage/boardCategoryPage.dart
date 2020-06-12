import 'package:dorf_app/models/boardCategory_model.dart';
import 'file:///C:/Users/R4pture/AndroidStudioProjects/dorfapp-frontend/lib/screens/forum/boardCategoryPage/widgets/boardCategoryDisplay.dart';
import 'package:dorf_app/services/boardCategory_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardCategoryPage extends StatefulWidget {
  @override
  _BoardCategoryPageState createState() => _BoardCategoryPageState();
}

class _BoardCategoryPageState extends State<BoardCategoryPage> {


  @override
  Widget build(BuildContext context) {
    final separatorIndent = MediaQuery.of(context).size.width * 0.05;

    return Scaffold(

      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BoardCategoryService()),
        ],
        child: Builder(
          builder: (context) {
            return FutureBuilder(
              future:
              Provider.of<BoardCategoryService>(context, listen: false)
                  .getBoardCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<BoardCategory>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BoardCategoryDisplay(snapshot.data[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          indent: separatorIndent,
                          endIndent: separatorIndent,
                        ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
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
      ),
    );
  }
}
