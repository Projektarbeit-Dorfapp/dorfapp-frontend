import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/subscription_service.dart';
import 'package:flutter/material.dart';
import '../news_detail.dart';

// Philipp Hellwich

class PinnedNews extends StatefulWidget {
  PinnedNews({Key key}) : super(key: key);

  @override
  _PinnedNewsState createState() => _PinnedNewsState();
}

class _PinnedNewsState extends State<PinnedNews> {
  final SubscriptionService _subService = new SubscriptionService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
        future:
            _subService.getPinnedDocuments(context, SubscriptionType.news, 10),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PageView.builder(
              itemCount: snapshot.data.length,
              scrollDirection: Axis.horizontal,
              controller: PageController(viewportFraction: 0.85, initialPage: 0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewsDetail(snapshot.data[index].documentID)));
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
                            padding:
                                EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                            child: Text(
                              snapshot.data[index].data['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          }
        });
  }
}
