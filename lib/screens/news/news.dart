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

  test() {
    this._newsService.getAllNews();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SearchBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  NewsCard('Hello1', 'Hello2', 'Hello3'),
                  FlatButton(
                    onPressed: () {
                      test();
                    },
                    child: Text("TEst")
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}