import 'dart:io';

import 'package:dorf_app/models/address_model.dart';
import 'package:dorf_app/models/comment_model.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/news/news_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  NewsCard(this.title, this.description, this.imagePath);

  NewsModel newsModel = NewsModel("72. Fränkisches Weinfest Volkach",
                                "Frankens größtes Weinfest - Zum 72. Mal feiert Volkach das Weingenießer-Spektakel der Region. Über 120 Frankenweine der Weinlagen rundum die Volkacher Mainschleife stehen während der Festtage zur Auswahl.\n\nTageskarte: 2,00 Euro pro Person\nDauerkarte: 5,50 Euro pro Person (Vorverkauf: 4,50 Euro)\nJugendliche ab 16 Jahren sind Eintrittspflichtig!\nDienstag, 17.08. (Weinfest-Zugabe) = Eintritt frei!\n\n(Preisänderungen bleiben vorbehalten!)",
                                "12:00",
                                "00:00",
                                "13.08.2021",
                                "21.08.2021",
                                Address(street: 'An der Allee', houseNumber: '1', zipCode: '97332', district: 'Volkach'),
                                "assets/weinfest2.jpg",
                                [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18],
                                List<Comment>());

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
                            MaterialPageRoute(builder: (context) => NewsDetail(newsModel)));
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