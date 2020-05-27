import 'package:dorf_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dorf_app/screens/news/like_detail.dart';

//Meike Nedwidek
class LikeSection extends StatefulWidget {

  List<User> likeList;

  LikeSection(this.likeList);

  @override
  _LikeSectionState createState() => _LikeSectionState(likeList);

}

class _LikeSectionState extends State<LikeSection> {

  List<User> likeList;
  Color iconColor = Color(0xFF141e3e);
  final User user = User(firstName: "Peter", lastName: "Müller", userName: "Peter123", email: "test");

  _LikeSectionState(this.likeList);

  bool _addLike() {

    bool isLiked = true;

    setState(() {
      if (likeList.contains(user)) {
        likeList.remove(user);
        isLiked = false;
      }
      else {
        likeList.add(user);
      }
    });
    return isLiked;
  }

  String _getNumberOfLikes() {

    return likeList.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: iconColor,
                  onPressed: (){
                    setState(() {
                      bool isLiked = _addLike();
                      if (isLiked){
                        iconColor = Colors.blue;
                      }
                      else {
                        iconColor = Color(0xFF141e3e);
                      }

                    });
                  },
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Gefällt " + _getNumberOfLikes(),
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  color: Colors.grey,
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LikeDetail(likeList: likeList))
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

}





