import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import '../news_detail.dart';
import 'date_detailview.dart';
import 'time_detailview.dart';

// Philipp Hellwich

class NewsCard extends StatelessWidget {
  News newsCard = new News();
  User _currentUser = new User();

  NewsCard(id, title, description, imagePath, startTime, endTime, createdAt,
      isNews) {
    this.newsCard.title = title;
    this.newsCard.id = id;
    this.newsCard.description = description;
    this.newsCard.imagePath = imagePath;
    this.newsCard.startTime = startTime;
    this.newsCard.endTime = endTime;
    this.newsCard.createdAt = createdAt;
    this.newsCard.isNews = isNews;
    this.newsCard.createdBy = createdBy;
    this._currentUser = currentUser;
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
                height: 200,
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
                    Row(
                      mainAxisAlignment : MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                            child: Text(
                              this.newsCard.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 16.0),
                                text: TextSpan(
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    text: this.newsCard.description),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                            child: DateDetailView(this.newsCard.convertTimestamp(this.newsCard.startTime),
                this.newsCard.convertTimestamp(this.newsCard.endTime), 14),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0), child: TimeDetailView(this.newsCard.convertTimestamp(this.newsCard.startTime),
                this.newsCard.convertTimestamp(this.newsCard.endTime), 14)
                )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                          child: RelativeDate(
                              this
                                  .newsCard
                                  .convertTimestamp(this.newsCard.createdAt),
                              Colors.white,
                              12.0),
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
