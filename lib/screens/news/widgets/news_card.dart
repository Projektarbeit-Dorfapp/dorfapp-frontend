import 'package:dorf_app/screens/news/news_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/services/news_service.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final _newsService = NewsService();
  
  NewsCard(this.title, this.description, this.imagePath);

  String newsID;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100,
            width: 150,
            child: Image.asset(imagePath)
          ),
          new Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewsDetail('Nui3l9g46jgYxt8jXrmY')));
                      },
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                ),
                Container(
                  child: Center(
                    child: Text(
                        description
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}