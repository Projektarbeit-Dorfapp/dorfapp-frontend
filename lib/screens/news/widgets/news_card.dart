import 'package:dorf_app/models/news_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/widgets/date_comment.dart';

import '../news_detail.dart';

class NewsCard extends StatelessWidget {
  NewsModel newsCard = new NewsModel();

  NewsCard(id, title, description, imagePath, createdAt) {
    this.newsCard.title = title;
    this.newsCard.id = id;
    this.newsCard.description = description;
    this.newsCard.imagePath = imagePath;
    this.newsCard.createdAt = createdAt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewsDetail(this.newsCard.id)));
              },
              child: Container(
                height: 125,
                margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  color: Color(0xFF141e3e),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                        child: Text(
                          this.newsCard.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0.0),
                        child: Text(
                          newsCard.description,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontFamily: 'Raleway', fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          child: DateComment(
                              this
                                  .newsCard
                                  .convertTimestamp(this.newsCard.createdAt),
                              Colors.white),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 15.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 20,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  onPressed: () {
                                    print("Comment");
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
