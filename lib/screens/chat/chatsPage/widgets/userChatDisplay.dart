import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/screens/general/userAvatarDisplay.dart';
import 'package:dorf_app/screens/chat/chatRoom/chatRoom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Matthias Maxelon
class UserDisplay extends StatelessWidget {
  final OpenChat openChat;
  UserDisplay({this.openChat});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (BuildContext context) => ChatRoom(selectedUser: openChat.user, chatID: openChat.chatID, role: openChat.role)));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Container(
                height: 50,
                width: 75,
                child: Stack(
                  children: [
                    UserAvatarDisplay(
                        50, 50),
                    Positioned(
                      left: 38,

                      child: openChat.unreadMessages > 0 ? Padding(
                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).buttonColor,
                            borderRadius: BorderRadius.circular(50),

                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                openChat.unreadMessages.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17
                                ),
                              ),
                            ),

                          ),
                        ),
                      ) : Container(),
                    )
                  ],
                ),
              ),
              SizedBox(width: 20,),
              Text(openChat.user.firstName + " " + openChat.user.lastName, style: TextStyle(
                  fontSize: 20
              ),),
              Spacer(),


            ],
          ),
        ),
      ),
    );
  }
}
class SimpleQuantityDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}


