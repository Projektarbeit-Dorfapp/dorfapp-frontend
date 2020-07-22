import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/like_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dorf_app/screens/general/like_detail.dart';
import 'package:provider/provider.dart';

//Meike Nedwidek
class LikeSection extends StatefulWidget {

  final List<User> likeList;
  final String document;
  final String collection;

  LikeSection(this.likeList, this.document, this.collection);

  @override
  _LikeSectionState createState() => _LikeSectionState(likeList, document, collection);

}

class _LikeSectionState extends State<LikeSection> {
  final likeService = LikeService();
  List<User> likeList;
  String document;
  String collection;
  Color iconColor = Color(0xFF141e3e);
  bool isLiked;

  _LikeSectionState(this.likeList, this.document, this.collection);

  bool _addLike() {

    setState(() {
      AccessHandler _accessHandler = Provider.of<AccessHandler>(context, listen: false);
      User user = _accessHandler.getUser();
      if (likeList.any((element) => element.uid == _accessHandler.getUID())) {
        isLiked = false;
        likeService.deleteLike(user, document, collection);
        likeList.remove(likeList.firstWhere((element) => element.uid == _accessHandler.getUID()));
      }
      else {
        isLiked = true;
        likeService.insertLike(user, document, collection);
        likeList.add(user);
      }
    });
    return isLiked;
  }

  String _getNumberOfLikes() {

    if (likeList != null) {
      return likeList?.length.toString();
    } else {
      return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    AccessHandler _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    isLiked = likeList.any((element) => element.uid == _accessHandler.getUID());
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: isLiked ? Colors.blue : Color(0xFF141e3e),
                  onPressed: () async{
                    setState(() {
                      isLiked = _addLike();
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





