import 'package:dorf_app/screens/news/widgets/news_card.dart';
import 'package:flutter/cupertino.dart';

class News extends StatelessWidget {



  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: <Widget>[
         NewsCard('News 1', 'Example description','assets/australian-shepherd-2208371_1920.jpg'),
         NewsCard('News 2', 'Example description', 'assets/azalea-5012549_1920.jpg'),
         NewsCard('News 3', 'Example description', 'assets/church-4911852_1920.jpg'),
         NewsCard('News 4', 'Example description', 'assets/australian-shepherd-2208371_1920.jpg'),
         NewsCard('News 5', 'Example description', 'assets/azalea-5012549_1920.jpg'),
       ],
      ),
    );
  }
}