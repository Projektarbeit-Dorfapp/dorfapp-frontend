import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/news/widgets/address_detailview.dart';
import 'package:dorf_app/widgets/comment_section.dart';
import 'package:dorf_app/screens/news/widgets/date_detailview.dart';
import 'package:dorf_app/widgets/like_section.dart';
import 'package:dorf_app/screens/news/widgets/time_detailview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/news_service.dart';


//Meike Nedwidek
class NewsDetail extends StatelessWidget {

  NewsModel newsModel;
  String newsID;
  final _newsService = NewsService();

  NewsDetail(this.newsID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NewsModel>(
      future: _newsService.getNews(newsID),
      builder: (context, AsyncSnapshot<NewsModel> snapshot) {
        if (snapshot.hasData) {
          this.newsModel = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF6178a3),
              ),
              body: Container(
                  color: Colors.white,
                  constraints: new BoxConstraints.expand(),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _getImageStack(),
                      Container(
                        padding: EdgeInsets.all(15.0),
                        margin: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Color(0xFF141e3e),
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Column(
                          children: <Widget>[
                            DateDetailView(newsModel.startTime, newsModel.endTime),
                            TimeDetailView(newsModel.startTime, newsModel.endTime),
                            AddressDetailView(newsModel.address)
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
                          child: Text(
                            newsModel.description,
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black
                            ),
                          )
                      ),
                      Container(
                          child: LikeSection(newsModel.likes)
                      ),
                      Container(
                          child: CommentSection(newsModel.comments)
                      )
                    ],
                  )
              )
          );
        }
        else {
          return Center(
            child: Text(
              'Lädt...',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 40.0
              ),
            )
          );
        }
      },
    );
  }

  _getImageStack() {
    if (newsModel.imagePath == ''){
      return Container();
    }
    return Stack(
      children: <Widget>[
        Container(
          child: Image.asset(newsModel.imagePath, fit: BoxFit.cover),
          constraints: BoxConstraints.expand(height: 300.0)
        ),
        Container(
          margin: EdgeInsets.only(top: 200.0),
          height: 100.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.white]
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 70.0),
              child: Center(
                  child: Text(
                      newsModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.black54
                      )
                  )
              )
          ),
        )
      ],
    );
  }
}

