import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:dorf_app/constants/page_indexes.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/home/home.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/widgets/address_detailview.dart';
import 'package:dorf_app/screens/news_edit/news_edit.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:dorf_app/widgets/comment_section.dart';
import 'package:dorf_app/screens/news/widgets/date_detailview.dart';
import 'package:dorf_app/widgets/like_section.dart';
import 'package:dorf_app/screens/news/widgets/time_detailview.dart';
import 'package:dorf_app/widgets/subscription_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:dorf_app/services/news_service.dart';
import 'package:provider/provider.dart';

class NewsDetail extends StatefulWidget {
  final newsID;
  NewsDetail(this.newsID);
  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  News newsModel;
  AccessHandler _accessHandler;
  String _userID;
  final _newsService = NewsService();

  @override
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    _accessHandler.getUID().then((uid){
      _userID = uid;
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<News>(
      future: _newsService.getNews(widget.newsID),
      builder: (context, AsyncSnapshot<News> snapshot) {
        if (snapshot.hasData) {
          this.newsModel = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF6178a3),
                actions: <Widget>[
                  _getPopupMenuButton(_userID)
                      ? PopupMenuButton<String>(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    onSelected: (value) => _choiceAction(value, context),
                    color: Colors.white,
                    itemBuilder: (BuildContext context) {
                      return MenuButtons.EditDelete.map((String choice) {
                        return PopupMenuItem<String>(value: choice, child: Text(choice));
                      }).toList();
                    },
                  )
                      : IconButton(
                    icon: Icon(null),
                    onPressed: null,
                  ),
                ],
              ),
              body: Container(
                  color: Colors.white,
                  constraints: new BoxConstraints.expand(),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _getImageAndTitle(),
                      _getEventInfo(),
                      Container(
                          padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                          child: Text(
                            newsModel.description,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black),
                          )),
                      Row(
                        children: <Widget>[
                          LikeSection(newsModel.likes, widget.newsID, "Veranstaltung", _userID),
                          Spacer(),
                          SubscriptionSection(widget.newsID, newsModel.bookmarks, _userID)
                        ],
                      ),
                      CommentSection(newsModel.comments, widget.newsID, "Veranstaltung"),
                    ],
                  )));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Container(color: Colors.white, child: Center(child: CircularProgressIndicator())));
        } else {
          return Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(
                  child: Text(
                    'keine Daten ...',
                    style: TextStyle(
                        fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 40.0, color: Colors.black),
                  ),
                ),
              ));
        }
      },
    );
}



  bool _getPopupMenuButton(String uid) {
    if (uid == this.newsModel.createdBy) {
      return true;
    }
    return false;
  }

  _getImageAndTitle() {
    if (newsModel.imagePath == null) {
      return Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Center(
              child: Text(newsModel.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black54))));
    }
    return Stack(
      children: <Widget>[
        Container(
            child: Image.asset(newsModel.imagePath, fit: BoxFit.cover),
            constraints: BoxConstraints.expand(height: 300.0)),
        Container(
          margin: EdgeInsets.only(top: 200.0),
          height: 100.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.white]),
          ),
          child: Container(
              margin: EdgeInsets.only(top: 70.0),
              child: Center(
                  child: Text(newsModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway', fontWeight: FontWeight.w600, fontSize: 22, color: Colors.black54)))),
        )
      ],
    );
  }

  Container _getEventInfo() {
    if (newsModel.isNews == false) {
      return Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.all(20.0),
        decoration: BoxDecoration(color: Color(0xFF141e3e), borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            DateDetailView(
                newsModel.convertTimestamp(newsModel.startTime), newsModel.convertTimestamp(newsModel.endTime)),
            TimeDetailView(
                newsModel.convertTimestamp(newsModel.startTime), newsModel.convertTimestamp(newsModel.endTime)),
            AddressDetailView(newsModel.address)
          ],
        ),
      );
    }
    return Container();
  }

  void _choiceAction(String choice, BuildContext context) {
    if (choice == MenuButtons.EDIT) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => NewsEdit(widget.newsID)));
    } else if (choice == MenuButtons.DELETE) {
      Firestore.instance.collection('Veranstaltung').document(widget.newsID).delete();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(PageIndexes.NEWSINDEX)));
    } else if (choice == MenuButtons.LOGOUT) {
      final accessHandler = Provider.of<AccessHandler>(context, listen: false);
      accessHandler.logout();
    }
  }
}
