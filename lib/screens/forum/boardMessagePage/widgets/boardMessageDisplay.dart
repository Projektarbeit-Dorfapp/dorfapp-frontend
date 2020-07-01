import 'package:dorf_app/helperFunctions/transform_post_date.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/userAvatarDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/widgets/boardMessageLikeButton.dart';
import 'package:dorf_app/services/boardMessage_service.dart';
import 'package:flutter/material.dart';


class BoardMessageDisplay extends StatelessWidget {
  final BoardMessageWithUser messageWithUser;
  const BoardMessageDisplay(this.messageWithUser);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Material(
        color: Colors.white,
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
                        messageWithUser.user.userName,
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
                    SizedBox(width: 60),
                      const Icon(
                      Icons.date_range,
                      size: 12,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      TransformPostDate.transform(
                          messageWithUser.message.postingDate.toDate()),
                      style: const TextStyle(
                          fontFamily: "Raleway",
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    messageWithUser.message.lastModifiedDate !=
                        messageWithUser.message.postingDate
                        ? const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 12,
                    )
                        : Container(),
                    const SizedBox(width: 5),
                    messageWithUser.message.lastModifiedDate !=
                        messageWithUser.message.postingDate
                        ? Text(
                      TransformPostDate.transform(
                          messageWithUser.message.lastModifiedDate
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
                  padding: EdgeInsets.only(left: 16, top: 10),
                  child: Text(
                    messageWithUser.message.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "Raleway",
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
