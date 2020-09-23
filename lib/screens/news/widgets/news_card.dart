import 'package:dorf_app/models/news_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import '../news_detail.dart';

// Philipp Hellwich

class NewsCard extends StatelessWidget {
  News newsCard = new News();

  NewsCard(id, title, description, imagePath, startTime, endTime) {
    this.newsCard.title = title;
    this.newsCard.id = id;
    this.newsCard.description = description;
    this.newsCard.imagePath = imagePath;
    this.newsCard.startTime = endTime;
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
                height: 130,
                margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                            child: Text(
                              createDateString(),
                              style: TextStyle(color: Colors.white),
                            )),
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

  String createDateString() {
    String startTime =
        this.newsCard.convertTimestamp(this.newsCard.startTime).toString();
    String endTime =
        this.newsCard.convertTimestamp(this.newsCard.endTime).toString();
    if (endTime == 'null') {
      return "Vom " + startTime.split('.')[0];
    } 
    return "Von " + startTime.split('.')[0] + " bis " + endTime.split('.')[0];
  }
}
