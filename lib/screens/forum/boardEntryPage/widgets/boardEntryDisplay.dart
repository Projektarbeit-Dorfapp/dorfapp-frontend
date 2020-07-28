import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:dorf_app/screens/forum/boardEntryPage/widgets/userAvatarDisplay.dart';
import 'package:dorf_app/screens/forum/boardMessagePage/boardMessagePage.dart';
import 'package:dorf_app/services/boardEntry_service.dart';
import 'package:dorf_app/widgets/relative_date.dart';
import 'package:dorf_app/widgets/showUserProfileText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BoardEntryDisplay extends StatelessWidget {
  final BoardEntry entry;
  final BoardCategory category;
  const BoardEntryDisplay({@required this.entry, @required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: (){
          _showBoardMessagePage(context);
        },
        child: Material(
          elevation: 2,
          child: Container(
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
                              child: ShowUserProfileText(
                                userReference: entry.userReference,
                                userName: entry.userName,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            entry.isClosed ? Padding(
                              padding: EdgeInsets.only(left: 150, top: 15),
                                child: Text("Geschlossen",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontFamily: "Raleway"
                                ),)

                                ) : Container(),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 60),
                            const Icon(Icons.visibility, size: 14, color: Colors.grey,),
                            const SizedBox(width: 5),
                            entry.watchCount != 0
                                ? Text(entry.watchCount.toString(), style: TextStyle(color: Colors.grey),)
                                : Text(0.toString(), style: TextStyle(color: Colors.grey)),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.date_range,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            RelativeDate(
                                entry.postingDate.toDate(), Colors.grey, 12),
                            const SizedBox(
                              width: 10,
                            ),
                            entry.lastModifiedDate != entry.postingDate
                                ? const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 12,
                                  )
                                : Container(),
                            const SizedBox(width: 5),
                            entry.lastModifiedDate != entry.postingDate
                                ? RelativeDate(entry.lastModifiedDate.toDate(),
                                    Colors.grey, 12)
                                : Container()
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, top: 5),
                          child: Text(
                            entry.title,
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
              ),
        ),
      ),
    );
  }
  _showBoardMessagePage(BuildContext context){
    BoardEntryService().incrementWatchCount(entry);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BoardMessagePage(
          categoryDocumentID: category.documentID,
          entryDocumentID: entry.documentID,),));
  }
}
