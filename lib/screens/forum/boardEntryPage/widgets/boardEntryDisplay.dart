import 'package:animations/animations.dart';
import 'package:dorf_app/helperFunctions/transform_post_date.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/userAvatarDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/boardMessagePage.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardEntryDisplay extends StatelessWidget {
  final EntryWithUser entryWithUser;
  final BoardCategory category;
  const BoardEntryDisplay({@required this.entryWithUser, @required this.category});
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
        transitionDuration: const Duration(milliseconds: 300),
        openBuilder: (context, action) {
          return BoardMessagePage(
            entry: entryWithUser.entry,
            category: category,
          );
        },
        closedBuilder: (context, action) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 16,
                  top: 13,
                  child: UserAvatarDisplay(//TODO: Fetch from storage
                  ),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                      size: 25,
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
                          padding: EdgeInsets.only(left: 60, top: 10),
                          child: Text(
                            entryWithUser.user.userName,
                            style: const TextStyle(
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        const SizedBox(width: 60),
                        const Icon(
                          Icons.date_range,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          TransformPostDate.transform(
                              entryWithUser.entry.postingDate.toDate()),
                          style: const TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.grey),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        entryWithUser.entry.lastModifiedDate !=
                            entryWithUser.entry.postingDate
                            ? const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 12,
                        )
                            : Container(),
                        const SizedBox(width: 5),
                        entryWithUser.entry.lastModifiedDate !=
                            entryWithUser.entry.postingDate
                            ? Text(
                          TransformPostDate.transform(
                              entryWithUser.entry.lastModifiedDate
                              .toDate()),
                          style: const TextStyle(
                              fontFamily: "Raleway",
                              fontSize: 12,
                              color: Colors.grey),
                        )
                            : Container()
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16, top: 5),
                      child: Text(
                        entryWithUser.entry.title,
                        style: const TextStyle(
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
}