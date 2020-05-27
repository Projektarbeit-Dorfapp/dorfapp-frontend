import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/news/widgets/comment_section.dart';
import 'package:dorf_app/screens/news/widgets/dateDetailView.dart';
import 'package:dorf_app/screens/news/widgets/like_section.dart';
import 'package:dorf_app/screens/news/widgets/timeDetailView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


//Meike Nedwidek
class NewsDetail extends StatelessWidget {

  final NewsModel newsModel;

  NewsDetail(this.newsModel);

  @override
  Widget build(BuildContext context) {
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
            getImageStack(),
            Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color(0xFF141e3e),
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                children: <Widget>[
                  DateDetailView(newsModel.start, newsModel.end),
                  TimeDetailView(newsModel.start, newsModel.end),
                  getAddressRow()
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

  getImageStack() {
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

  getAddressRow() {
    if(newsModel.address == null){
      return Row();
    }

    return Row(
        children: <Widget>[
          Icon(
            Icons.location_on,
            color: Colors.white,
            size: 22.0
          ),
          Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(
                newsModel.address.getAddressFormat(),
                style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.white
                ),
              )
          )
        ]
    );
  }
}

