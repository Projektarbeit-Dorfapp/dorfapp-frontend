import 'package:dorf_app/screens/news_edit/news_edit.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/news/widgets/news_card.dart';
import 'package:dorf_app/screens/news/widgets/search_bar.dart';
import 'package:dorf_app/services/news_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class News extends StatelessWidget {
  List<NewsModel> news;

  final _newsService = new NewsService();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SearchBar(),
          FutureBuilder(
            future: _newsService.getAllNews(),
            builder: (context, AsyncSnapshot<List<NewsModel>> snapshot) {
              if (snapshot.hasData) {
                this.news = snapshot.data;
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: 
                          news.length > 0 ? news.map<Widget>((newsModel) => prepareNewsCards(newsModel)).toList() : [_getTextIfNewsListEmpty()]
                      )
                    ]
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }

  prepareNewsCards(NewsModel newsModel) {
    return new NewsCard(newsModel.id, newsModel.title, newsModel.description, newsModel.imagePath, newsModel.createdAt);
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
                  )
                )
            ]
          )
        );
  }
}
