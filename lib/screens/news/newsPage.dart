import 'package:dorf_app/screens/news/widgets/clock.dart';
import 'package:dorf_app/screens/news/widgets/dateTimeDisplay.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/screens/news/widgets/weatherDisplay.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather_library.dart';

class NewsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              expandedHeight: 80,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Clock(),
                          Spacer(),
                          UserAvatar(safeAreaHeight),
                        ],
                      ),
                      DateTimeDisplay(),
                    ],

                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Deine ",
                      style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: 'Raleway'),
                    ),
                    Icon(Icons.pin_drop,
                      color: Colors.blueGrey,
                      size: 16,),
                  ],

                ),
              ),
            ),
            ///Gepinnte Karte
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 150,
                child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: PageController(
                    viewportFraction: 0.7,
                    initialPage: 0,
                  ),
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text("Philcard", style: TextStyle(fontSize: 30, color: Colors.white),),
                              ),
                            ),
                          ),
                        ),
                        color: Color(0xff6FB3A9),
                        elevation: 2,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Neuigkeiten auf einem Blick",
                  style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: "Raleway"),
                ),
              ),
            ),
            ///Neuigkeiten
            SliverList(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container(
                  width: 200,
                  height: 200,
                  child: Card(
                    child: Center(child: Text("Philcard", style: TextStyle(fontSize: 30, color: Colors.white),)),
                    color: Color(0xffB39081),
                    elevation: 2,
                  ),
                );
              }, childCount: 10,),
            ),
          ],
        ),
      ),
    );
  }

}