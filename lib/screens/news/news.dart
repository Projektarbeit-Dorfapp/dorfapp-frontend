import 'package:dorf_app/screens/general/alertQuantityDisplay.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/screens/news/widgets/weatherDisplay.dart';
import 'package:dorf_app/screens/news_edit/news_edit.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/news_model.dart';
import '../../services/news_service.dart';
import 'widgets/news_card.dart';

class NewsOverview extends StatelessWidget {

  final _newsService = new NewsService();

  @override
  Widget build(BuildContext context) {
    List<News> news;
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
                          WeatherDisplay(),
                          Spacer(),
                          Container(
                            height: 70,
                            width: 70,
                            child: Stack(
                              children: <Widget>[
                                UserAvatar(safeAreaHeight, 50, 50),
                                Consumer<AlertService>(
                                  builder: (context, alertService, _){
                                    return Positioned(
                                      right: 8,
                                      top: 8,
                                      child: AlertQuantityDisplay(
                                        showIcon: true,
                                        iconSize: 18,
                                        iconColor: Colors.white,
                                        width: 23,
                                        height: 23,
                                        color: Theme.of(context).buttonColor,
                                        borderRadius: 50,
                                        textColor: Colors.white,
                                      ),
                                    );
                                  },

                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "Deine ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                            fontFamily: 'Raleway'),
                      ),
                      Icon(
                        Icons.pin_drop,
                        color: Colors.blueGrey,
                        size: 16,
                      ),
                    ],
                  ),
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
                                child: Text(
                                  "Philcard",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
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
              child: Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Neuigkeiten auf einem Blick",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blueGrey,
                        fontFamily: "Raleway"),
                  ),
                ),
              ),
            ),

            ///Neuigkeiten
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return FutureBuilder(
                  future: _newsService.getAllNews(),
                  builder: (context, AsyncSnapshot<List<News>> snapshot) {
                    if (snapshot.hasData) {
                      news = snapshot.data;
                      return SingleChildScrollView(
                        child: Column(children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: news.length > 0
                                  ? news
                                      .map<Widget>((newsModel) =>
                                          prepareNewsCards(newsModel))
                                      .toList()
                                  : [_getTextIfNewsListEmpty()])
                        ]),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container(
                          color: Colors.white,
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            'keine Daten ...',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                fontSize: 40.0,
                                color: Colors.black),
                          ),
                        ),
                      );
                    }
                  },
                );
              }, childCount: 1),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewsEdit()));
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF548c58)
        ),
      ),
    );
  }

  prepareNewsCards(News newsModel) {
    return new NewsCard(newsModel.id, newsModel.title, newsModel.description,
        newsModel.imagePath, newsModel.createdAt);
  }

  Container _getTextIfNewsListEmpty() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.message, color: Colors.grey, size: 80.0),
              Container(
                  margin: EdgeInsets.only(left: 10.0),
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Noch keine Neuigkeiten',
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey),
                  ))
            ]));
  }
}
