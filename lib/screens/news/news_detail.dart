import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/news/widgets/comment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewsDetail extends StatelessWidget {

  final NewsModel newsModel;

  NewsDetail(this.newsModel);

  //only for testing
  Comment comment1 = Comment(id: 0, content: "Wow, da freue ich mich schon voll drauf!!!11elf Das wird spitzenmäßig", authorName: "Melinda Schubert");
  Comment comment2 = Comment(id: 0, content: "Subbaaa", authorName: "Christian Bieber");

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
                  getDateRow(),
                  getTimeRow(),
                  getAddressRow()
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
              child: Text(
                newsModel.description,
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),
              )
            ),
            Container(
              color: Color(0xFFE6E6E6),
              padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CommentCard(comment: comment1),
                  CommentCard(comment: comment1),
                  CommentCard(comment: comment1),
                  CommentCard(comment: comment1),
                  CommentCard(comment: comment2)
                ],
              ),
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
              colors: [Colors.transparent, Colors.white],

            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 50.0),
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

  getDateRow() {
    if (newsModel.startDate == '') {
      return Row();
    }

    return Row(
        children: getDateColumns()
    );
  }

  getDateColumns() {
    if(newsModel.startDate != '' && newsModel.endDate == '') {
      return <Widget>[
        getStartDateRow()
      ];
    }

    return <Widget>[
      getStartDateRow(),
      getEndDateColumn()
    ];
  }

  getStartDateRow() {
    return Row(
      children: <Widget>[
        Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 22.0
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
              newsModel.startDate,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white
              )
          ),
        )
      ],
    );
  }

  getEndDateColumn() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
              ' - ' + newsModel.endDate,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white
              )
          ),
        )
      ],
    );
  }

  getTimeRow() {
    if(newsModel.startTime == '') {
      return Row();
    }

    return Row(
        children: getTimeColumns()
    );
  }

  getTimeColumns() {
    if(newsModel.startTime != '' && newsModel.endTime == '') {
      return <Widget>[
        getStartTimeRow()
      ];
    }

    return <Widget>[
      getStartTimeRow(),
      getEndTimeColumn()
    ];
  }

  getStartTimeRow() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.access_time,
          color: Colors.white,
          size: 22.0
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Text(
              newsModel.startTime,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white
              )
          ),
        )
      ],
    );
  }

  getEndTimeColumn() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 0.0, top: 10.0, right: 20.0, bottom: 10.0),
          child: Text(
              ' bis ' + newsModel.endTime,
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white
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

