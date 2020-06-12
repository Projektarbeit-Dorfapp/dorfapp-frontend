import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/userAvatarDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/boardMessagePage.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardEntryDisplay extends StatefulWidget {
  final EntryWithUser entryWithUser;
  final BoardCategory category;

  BoardEntryDisplay({@required this.entryWithUser, @required this.category});
  @override
  _BoardEntryDisplayState createState() => _BoardEntryDisplayState();
}

class _BoardEntryDisplayState extends State<BoardEntryDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: OpenContainer(
        closedElevation: 1.5,
        openElevation: 15.0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        transitionType: ContainerTransitionType.fade,
        transitionDuration: const Duration(milliseconds: 450),
        openBuilder: (context, action) {
          return BoardMessagePage(
            entry: widget.entryWithUser.entry,
            category: widget.category,
          );
        },
        closedBuilder: (context, action) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 13,
                  top: 9,
                  child: UserAvatarDisplay(//TODO: Fetch from storage
                      ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      //TODO: What to do?
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 50, top: 10),
                          child: Text(
                            widget.entryWithUser.user.userName,
                            style: TextStyle(
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 50),
                        Icon(
                          Icons.date_range,
                          size: 11,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text(
                          _transformPostDate(
                              widget.entryWithUser.entry.postingDate.toDate()),
                          style: TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 10,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        widget.entryWithUser.entry.lastModifiedDate != null
                            ? Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 11,
                              )
                            : Container(),
                        SizedBox(width: 5),
                        widget.entryWithUser.entry.lastModifiedDate != null
                            ? Text(
                                _transformPostDate(widget
                                    .entryWithUser.entry.lastModifiedDate
                                    .toDate()),
                                style: TextStyle(
                                    fontFamily: "Raleway",
                                    fontSize: 10,
                                    color: Colors.grey),
                              )
                            : Container()
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 2),
                      child: Text(
                        widget.entryWithUser.entry.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _transformPostDate(DateTime date) {
    DateTime entryDate = date;
    DateTime currentDate = DateTime.now();
    int dayDifference = currentDate.difference(entryDate).inDays;
    String transformedText = "";
    if (dayDifference == 0) {
      transformedText = _transformToHours(entryDate, currentDate);
    } else if (dayDifference == 1) {
      transformedText = dayDifference.toString() + " Tag";
    } else if (dayDifference > 28) {
      return _transformToFullDate(entryDate, currentDate);
    } else {
      transformedText = dayDifference.toString() + " Tage";
    }
    return transformedText;
  }

  String _transformToFullDate(DateTime postingDate, DateTime currentDate) {
    return postingDate.day.toString() +
        "." +
        postingDate.month.toString() +
        "." +
        postingDate.year.toString();
  }

  String _transformToHours(DateTime postingDate, DateTime currentDate) {
    int hourDifference = currentDate.difference(postingDate).inHours;
    String transformedText = "";
    if (hourDifference == 0) {
      return _transformToMinutes(postingDate, currentDate);
    } else if (hourDifference == 1) {
      transformedText = hourDifference.toString() + " Stunde";
    } else {
      transformedText = hourDifference.toString() + " Stunden";
    }
    return transformedText;
  }

  String _transformToMinutes(DateTime postingDate, DateTime currentDate) {
    int minuteDifference = currentDate.difference(postingDate).inMinutes;
    String transformedText = "";
    if (minuteDifference == 0) {
      transformedText = "Gerade eben";
    }
    if (minuteDifference == 1) {
      transformedText = minuteDifference.toString() + " Minute";
    } else if (minuteDifference > 1 && minuteDifference < 61) {
      transformedText = minuteDifference.toString() + " Minuten";
    }
    return transformedText;
  }
}
