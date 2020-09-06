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
  final String userID;
  final Color likeDetailAppbarColor;
  final Color likedColor;
  final Color notLikedColor;
  LikeSection(this.likeList, this.document, this.collection, this.userID, {this.likedColor, this.notLikedColor, this.likeDetailAppbarColor});

  @override
  _LikeSectionState createState() => _LikeSectionState(likeList, document, collection, userID);

}

class _LikeSectionState extends State<LikeSection> {
  final likeService = LikeService();
  AccessHandler _accessHandler;
  List<User> likeList;
  String _userID;
  String document;
  String collection;
  Color iconColor = Color(0xFF141e3e);
  bool isLiked;


  _LikeSectionState(this.likeList, this.document, this.collection, this._userID);

  Future<bool> _addLike() async{
    User user = await _accessHandler.getUser();
    setState(()  {
      if (likeList.any((element) => element.uid == _userID)) {
        isLiked = false;
        likeService.deleteLike(user, document, collection);
        likeList.remove(likeList.firstWhere((element) => element.uid == _userID));
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
  void initState() {
    _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    isLiked = likeList.any((element) => element.uid == _userID);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: _getLikeColor(),
                  onPressed: () async{
                    isLiked = await _addLike();
                    setState(() {});
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
                      MaterialPageRoute(builder: (context) => LikeDetail(likeList: likeList, appbarColor: widget.likeDetailAppbarColor,))
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
  Color _getLikeColor(){
    if(isLiked)
      return widget.likedColor != null ? widget.likedColor : Colors.blue;
    else
      return widget.notLikedColor != null ? widget.notLikedColor : Color(0xFF141e3e);
  }

}





