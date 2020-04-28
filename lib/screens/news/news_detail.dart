import 'package:dorf_app/models/news_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        constraints: new BoxConstraints.expand(),
        color: Color(0xFFFFFF),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                      newsModel.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 28
                      )
                  )
              )
            ),
            getImageContainer(),
            getDateRow(),
            getTimeRow(newsModel.startTime, "Beginn: "),
            getTimeRow(newsModel.endTime, "Ende: "),
            getAddressRow(),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                newsModel.description,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20
                ),
              )
            )
          ],
        )
      )
    );
  }

  getImageContainer() {
    if (newsModel.imagePath == ''){
      return Container();
    }

    return Container(
      child: Image.asset(newsModel.imagePath),
    );
  }

  getDateRow() {
    if(newsModel.startDate == '') {
      return Row();
    }

    return Row(
        children: getDateColumns()
    );
  }

  getDateColumns() {
    if(newsModel.startDate != '' && newsModel.endDate == '') {
      return <Widget>[
        getStartDateColumn()
      ];
    }

    return <Widget>[
      getStartDateColumn(),
      getEndDateColumn()
    ];
  }

  getStartDateColumn() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 10.0),
          child: Text(
              'am ' + newsModel.startDate,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
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
          padding: EdgeInsets.only(left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Text(
              ' - ' + newsModel.endDate,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
              )
          ),
        )
      ],
    );
  }

  getTimeRow(String timeValue, String additionalTimeType) {
    if(timeValue == ''){
      return Row();
    }
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 10.0),
          child: Text(
            additionalTimeType + timeValue,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20
            ),
          )
        )
      ]
    );
  }

  getAddressRow() {
    if(newsModel.address == null){
      return Row();
    }

    return Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 0.0, bottom: 10.0),
              child: Text(
                'Veranstaltungsort: \n' + newsModel.address.getAddressFormat(),
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20
                ),
              )
          )
        ]
    );
  }
}