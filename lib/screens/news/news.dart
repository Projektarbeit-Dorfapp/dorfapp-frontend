import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/screens/general/alertQuantityDisplay.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/screens/news/widgets/weatherDisplay.dart';
import 'package:dorf_app/screens/news_edit/news_edit.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/services/auth/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../models/news_model.dart';
import '../../services/news_service.dart';
import 'widgets/news_card.dart';

class NewsOverview extends StatefulWidget {
  final double safeAreaHeight;
  NewsOverview({@required this.safeAreaHeight});
  @override
  _NewsOverviewState createState() => _NewsOverviewState();
}

class _NewsOverviewState extends State<NewsOverview> {
  final _newsService = new NewsService();
  UserService _userService;
  Authentication _auth;
  User _currentUser;
  bool _isDataLoaded = false;
  TextEditingController _searchController;
  String _searchTerm;
  String _sortMode = MenuButtons.SORT_DESCENDING;

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _userService = Provider.of<UserService>(context, listen: false);
    _auth = Provider.of<Authentication>(context, listen: false);
    _loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<News> news;
    return SafeArea(
      child: Scaffold(
        body: _isDataLoaded ? CustomScrollView(
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
                          WeatherDisplay(
                            textSize: 24,
                          ),
                          Spacer(),
                          Container(
                            height: 70,
                            width: 70,
                            child: Stack(
                              children: <Widget>[
                                UserAvatar(widget.safeAreaHeight, this._currentUser, 50, 50),
                                Consumer<AlertService>(
                                  builder: (context, alertService, _) {
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
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: 'Raleway'),
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
                                  style: TextStyle(fontSize: 30, color: Colors.white),
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
                child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(left: 15.0, right: 10.0, bottom: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10.0),
                              hintText: "Suche...",
                            ),
                            controller: _searchController,
                            onSubmitted: (String submittedStr) {
                              FocusManager.instance.primaryFocus.unfocus();
                              setState(() {
                                _searchTerm = submittedStr;
                              });
                            },
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
                          onSelected: (value) {
                            FocusManager.instance.primaryFocus.unfocus();
                            setState(() {
                              _sortMode = value;
                            });
                          },
                          color: Colors.white,
                          itemBuilder: (BuildContext context) {
                            return MenuButtons.NewsSorting.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ))),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Neuigkeiten auf einen Blick",
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: "Raleway"),
                  ),
                ),
              ),
            ),

            ///Neuigkeiten
            SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return FutureBuilder(
                  future: _newsService.getAllNews(_sortMode, _searchTerm?.toLowerCase()),
                  builder: (context, AsyncSnapshot<List<News>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Container(padding: EdgeInsets.all(100.0),child: Center(child: CircularProgressIndicator()));
                    } else if (snapshot.hasData) {
                      news = snapshot.data;
                      return SingleChildScrollView(
                        child: Column(children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: news.length > 0
                                  ? news.map<Widget>((newsModel) => prepareNewsCards(newsModel)).toList()
                                  : [_getTextIfNewsListEmpty()])
                        ]),
                      );
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
        ) : SizedBox.shrink(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsEdit()));
            },
            child: Icon(Icons.add),
            backgroundColor: Color(0xFF548c58)),
      ),
    );
  }

  prepareNewsCards(News newsModel) {
    return new NewsCard(newsModel.id, newsModel.title, newsModel.description, newsModel.imagePath, newsModel.createdAt);
  }

  Container _getTextIfNewsListEmpty() {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Icon(Icons.message, color: Colors.grey, size: 80.0),
          Container(
              margin: EdgeInsets.only(left: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Noch keine Neuigkeiten',
                style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
              ))
        ]));
  }

  _loadUserData() {
    _auth.getCurrentUser().then((firebaseUser) {
      _userService.getUser(firebaseUser.uid).then((fullUser) {
        _currentUser = fullUser;
        setState(() {
          _isDataLoaded = true;
        });
      });
    });
  }
}