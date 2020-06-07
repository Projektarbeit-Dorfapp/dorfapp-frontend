import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  // final String datum;

  NewsCard(this.title, this.description, this.imagePath);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: Container(
              height: 125,
              margin: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
              decoration: BoxDecoration(
                color: Color(0xff0b2566),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: Text(
                          "12.02.2020",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10.0),
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
                            Container(
                              width: 20,
                              child: IconButton(
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                onPressed: () {
                                  print("Like");
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
        ],
      ),
    );
  }
}