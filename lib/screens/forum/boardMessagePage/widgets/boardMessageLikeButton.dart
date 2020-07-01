import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';

class BoardMessageLikeButton extends StatefulWidget {
  final BoardMessage message;
  const BoardMessageLikeButton({@required this.message});
  @override
  _BoardMessageLikeButtonState createState() => _BoardMessageLikeButtonState();
}

class _BoardMessageLikeButtonState extends State<BoardMessageLikeButton> {
  BoardMessageService _boardMessageService;
  bool _currentIsLiked;
  int _currentLikes;
  //I think this function is super bad. Unfortunately, the order of the Listview in BoardMessagePage has to change order of each message
  //so when the order changes, the state of each like button stays on the same index of the listview.builder. So you have an ordered change of all messages, but not with
  //the correct state. The possible fix is to provide a UniqueKey() to each ListView item. But this seems to be very expensive and makes the App very laggy when the user is
  //popping back to the entry page. The bottom function is called, every time this widget has changed from the previous state. Which seems to fix the problem with false State and
  //the laggy animations but like UniqueKey() the amount of likes has to be fetched again from the database. How can we stop that.
  @override
  void didUpdateWidget(BoardMessageLikeButton oldWidget) {
    _boardMessageService
        .getLikesAndIsLikedCheck(widget.message)
        .then((likesAndIsLiked) {
      if(mounted){
        setState(() {
          _currentLikes = likesAndIsLiked[0];
          _currentIsLiked = likesAndIsLiked[1];
        });
      }
    });
    super.didUpdateWidget(oldWidget);
  }
  @override
  void initState() {
    _boardMessageService = BoardMessageService();
    _boardMessageService
        .getLikesAndIsLikedCheck(widget.message)
        .then((likesAndIsLiked) {
          if(mounted){
        setState(() {
          _currentLikes = likesAndIsLiked[0];
          _currentIsLiked = likesAndIsLiked[1];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentLikes != null && _currentIsLiked != null
        ? Padding(
            padding: EdgeInsets.only(left: 8),
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.thumb_up,
                      color: _currentIsLiked == true
                          ? Theme.of(context).buttonColor
                          : Colors.grey,
                    ),
                    onPressed: _onLikePress),
                _currentLikes > 0
                    ? Text(
                        _currentLikes.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: "Raleway",
                        ),
                      )
                    : Container()
              ],
            ),
          )
        : Padding(
      padding: EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(Icons.thumb_up),
            onPressed: (){

            },
            color: Colors.grey,
            ),
        );
  }

  _onLikePress() async {
    bool isInserted =
        await _boardMessageService.insertBoardMessageLike(widget.message);
    if (isInserted) {
      setState(() {
        _currentIsLiked = true;
        _currentLikes++;
      });
    } else {
      setState(() {
        _currentIsLiked = false;
        _currentLikes--;
      });
    }
  }
}
