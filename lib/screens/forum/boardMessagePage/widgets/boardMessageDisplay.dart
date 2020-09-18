
import 'package:dorf_app/models/boardMessage_model.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:dorf_app/widgets/showUserProfileText.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class BoardMessageDisplay extends StatelessWidget {
  final BoardMessage message;
  final String entryCreatorID;
  const BoardMessageDisplay(this.message, this.entryCreatorID);
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
              child: UserAvatarDisplay(30, 30 //TODO: Fetch from storage
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 60, top: 10),
                      child: ShowUserProfileText(
                        firstName: message.firstName,
                        lastName: message.lastName,
                        userName: message.userName,
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        userReference: message.userReference,
                      ),
                    ),
                    message.userReference == entryCreatorID
                        ? Padding(
                      padding: EdgeInsets.only(top: 10),
                          child: Icon(
                      Icons.stars,
                      color: Theme.of(context).buttonColor,
                          size: 22,),
                        )
                        : Container()
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
                    RelativeDate(
                        message.postingDate.toDate(),
                        Colors.grey,
                        12
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    message.lastModifiedDate !=
                        message.postingDate
                        ? const Icon(
                      Icons.edit,
                      color: Colors.grey,
                      size: 12,
                    )
                        : Container(),
                    const SizedBox(width: 5),
                    message.lastModifiedDate !=
                        message.postingDate
                        ? RelativeDate(
                        message.lastModifiedDate.toDate(),
                        Colors.grey,
                        12
                    )
                        : Container()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 10),
                  child: Text(
                    message.message,
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
