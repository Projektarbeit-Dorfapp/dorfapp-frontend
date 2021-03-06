import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/screens/general/alertQuantityDisplay.dart';
import 'package:dorf_app/screens/news/widgets/pinnedNews.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/screens/news/widgets/weatherDisplay.dart';
import 'package:dorf_app/screens/news/news_edit.dart';
import 'package:dorf_app/screens/profile/widgets/userSettings.dart';
import 'package:dorf_app/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/services/authentication_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/news_model.dart';
import '../../services/news_service.dart';
import 'widgets/news_card.dart';

// Philipp Hellwich & Kilian Berthold
class NewsOverview extends StatefulWidget {
  final double safeAreaHeight;

  NewsOverview({this.safeAreaHeight});

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
  DateTime _searchDate = null;

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
        body: _isDataLoaded
            ? CustomScrollView(
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
                                      GestureDetector(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10, top: 10),
                                          child: UserAvatar(
                                            width: 70,
                                            height: 70,
                                            userID: _currentUser.uid,
                                          ),
                                        ),
                                        onTap: () {
                                          _showDrawer(context);
                                        },
                                      ),
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
                              "Deine gepinnten News ",
                              style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: 'Raleway'),
                            ),
                            Icon(
                              Icons.bookmark_border,
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
                    child: Container(color: Colors.white, height: 100, child: PinnedNews()),
                  ),
                  SliverToBoxAdapter(
                      child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(left: 15.0, right: 10.0, bottom: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                        padding: EdgeInsets.only(left: 10.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black12),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Text("Nach Datum filtern: ", style: TextStyle(fontSize: 14)),
                                            Text(_searchDate == null ? "..." : DateFormat('dd.MM.yyyy').format(_searchDate),
                                                style: TextStyle(fontSize: 14)),
                                            Spacer(),
                                            IconButton(
                                                icon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                                                onPressed: () {
                                                  FocusManager.instance.primaryFocus.unfocus();
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: _searchDate ?? DateTime.now(),
                                                    firstDate: DateTime(2020, 1, 1),
                                                    lastDate: DateTime(2029, 12, 31),
                                                    locale: const Locale('de', ''),
                                                  ).then((date) {
                                                    setState(() {
                                                      _searchDate = date;
                                                    });
                                                  });
                                                }),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Theme.of(context).primaryColor),
                                              onPressed: () {
                                                FocusManager.instance.primaryFocus.unfocus();
                                                setState(() {
                                                  _searchDate = null;
                                                });
                                              },
                                            ),
                                          ],
                                        )),
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
                            ],
                          ))),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Alle Neuigkeiten auf einem Blick",
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey, fontFamily: "Raleway"),
                        ),
                      ),
                    ),
                  ),

                  ///Neuigkeiten
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                      return FutureBuilder(
                        future: _newsService.getAllNews(_sortMode, _searchTerm?.toLowerCase(), _searchDate),
                        builder: (context, AsyncSnapshot<List<News>> snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Container(padding: EdgeInsets.all(100.0), child: Center(child: CircularProgressIndicator()));
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
                                  style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 40.0, color: Colors.black),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }, childCount: 1),
                  ),
                ],
              )
            : SizedBox.shrink(),
        floatingActionButton: Container(
          width: 71,
          height: 71,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10, right: 10),
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewsEdit()));
                },
                child: Icon(Icons.add, size: 23,),
                backgroundColor: Theme.of(context).buttonColor),
          ),
        ),
      ),
    );
  }

  prepareNewsCards(News newsModel) {
    return new NewsCard(newsModel.id, newsModel.title, newsModel.description, newsModel.imagePath, newsModel.startTime, newsModel.endTime, newsModel.createdAt, newsModel.isNews);
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

  _showDrawer(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height - widget.safeAreaHeight,
              child: UserSettings(),
            ),
          );
        });
  }
}
