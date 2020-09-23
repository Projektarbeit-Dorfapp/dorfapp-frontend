import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/boardMessagePage.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:dorf_app/widgets/showUserProfileText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class BoardEntryDisplay extends StatelessWidget {
  final BoardEntry entry;
  final Color categoryColor;
  BoardEntryDisplay({@required this.entry, this.categoryColor});

  @override
  Widget build(BuildContext context) {
    final double _leftPosDistance = 17.0;
    final double _spaceBetweenIconAndNumber = 5.0;
    final double _spaceBetweenSection = 15.0;
    final double _detailIconSize = 15;
    final double _detailTextSize = 15;

    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () {
          _showBoardMessagePage(context);
        },
        child: Material(
          elevation: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: _leftPosDistance,
                  top: 13,
                  child: UserAvatar(height: 30, width: 30, userID: entry.createdBy,),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 60, top: 10),
                      child: Container(
                        child: ShowUserProfileText(
                          userReference: entry.createdBy,
                          userName: entry.userName,
                          firstName: entry.firstName,
                          lastName: entry.lastName,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 60),
                        Icon(
                          Icons.visibility,
                          size: _detailIconSize,
                          color: Colors.grey,
                        ),
                        SizedBox(width: _spaceBetweenIconAndNumber),
                        entry.watchCount != 0
                            ? Text(
                          entry.watchCount.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: _detailTextSize),
                        )
                            : Text(0.toString(), style: TextStyle(color: Colors.grey, fontSize: _detailTextSize)),
                        SizedBox(width: _spaceBetweenSection),
                        Icon(
                          Icons.date_range,
                          size: _detailIconSize,
                          color: Colors.grey,
                        ),
                        SizedBox(width: _spaceBetweenIconAndNumber),
                        RelativeDate(entry.postingDate.toDate(), Colors.grey, _detailTextSize),
                        SizedBox(
                          width: _spaceBetweenSection,
                        ),
                        entry.lastActivity != entry.postingDate
                            ? Icon(
                          Icons.comment,
                          color: Colors.grey,
                          size: _detailIconSize,
                        )
                            : Container(),
                        SizedBox(width: _spaceBetweenIconAndNumber),
                        entry.lastActivity != entry.postingDate
                            ? RelativeDate(entry.lastActivity.toDate(), Colors.grey, _detailTextSize)
                            : Container()
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: _leftPosDistance, top: 5),
                      child: Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: _leftPosDistance, top: 5, bottom: 20, right: _leftPosDistance),
                      child: Text(entry.description,
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: LikeAndMessageQuantityDisplay(
                        entry: entry,
                        textSize: _detailTextSize,
                        iconSize: _detailIconSize,
                        likes: entry.likeCount,
                        comments: entry.commentCount,
                        leftPosDistance: _leftPosDistance,
                        spaceBetweenIconAndNumber: _spaceBetweenIconAndNumber,
                        spaceBetweenSection: _spaceBetweenSection,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _showBoardMessagePage(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoardMessagePage(entryDocumentID: entry.documentID, boardCategoryColor: entry.categoryColor, boardCategoryHeadline: entry.boardCategoryTitle,),
        ));
    BoardEntryService().incrementWatchCount(entry.documentID);
  }
}

class LikeAndMessageQuantityDisplay extends StatelessWidget {
  final BoardEntry entry;
  final int likes;
  final double iconSize;
  final double textSize;
  final int comments;
  final double leftPosDistance;
  final double spaceBetweenIconAndNumber;
  final double spaceBetweenSection;
  LikeAndMessageQuantityDisplay(
      {@required this.likes,
      @required this.comments,
      @required this.leftPosDistance,
      @required this.spaceBetweenIconAndNumber,
      @required this.spaceBetweenSection,
      @required this.iconSize,
      @required this.textSize,
        @required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: leftPosDistance,
        ),
        Icon(
          Icons.thumb_up,
          color: Colors.grey,
          size: iconSize,
        ),
        SizedBox(
          width: spaceBetweenIconAndNumber,
        ),
        Text(
          likes != null ? likes.toString() : 0.toString(),
          style: TextStyle(color: Colors.grey, fontSize: textSize),
        ), //Text
        SizedBox(
          width: spaceBetweenSection,
        ),
        Icon(
          Icons.comment,
          size: iconSize,
          color: Colors.grey,
        ),
        SizedBox(
          width: spaceBetweenIconAndNumber,
        ),
        Text(
          comments != null ? comments.toString() : 0.toString(),
          style: TextStyle(color: Colors.grey, fontSize: textSize),
        ),
        SizedBox(width: spaceBetweenSection,),
        entry.isClosed ? Text("Thema Geschlossen", style: TextStyle(fontSize: textSize, color: Colors.grey),) : Container()
      ],
    );
  }
}
