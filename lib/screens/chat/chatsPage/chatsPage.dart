import 'package:animations/animations.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatsPage/widgets/userChatDisplay.dart';
import 'package:dorf_app/screens/chat/newChat/newChatPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatInformation{
  List<User> municipalUsers;
  List<User> openConnections; //TODO: ???
ChatInformation({this.municipalUsers, this.openConnections});
}
class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _getInitialData(context),
        builder: (context, AsyncSnapshot<ChatInformation> snapshot){
          if(snapshot.hasData){
            return Stack(
              children: [
                ActiveChats(snapshot.data),
                NewChatNavigation(municipal: snapshot.data.municipalUsers,)
              ],
            );
          }
          else if (snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("Etwas ist schief gelaufen"),
            );
          }
        },
      )
    );
  }

  Future<ChatInformation> _getInitialData(BuildContext context) async{
    final userS = Provider.of<UserService>(context, listen: false);
    final access = Provider.of<AccessHandler>(context, listen: false);

    List<User> municipalUsers = await userS.getUsers(await access.getUser());
    List<User> openConnections = [];

    //TODO: Get all active chats that the user participates on
    return ChatInformation(
      municipalUsers: municipalUsers,
      openConnections: openConnections //TODO: Take correct connectionData
    );
  }
  //TODO: Fetch from [CollectionNames.User] -> [Collection.Chats]. The Fetched documents should have the following information:
  //TODO: 1. userName (Needed to find selected ChatID to show correct ChatRoom) 2. The UserID that the loggedUser has an open connection
  //TODO: Return a List<User> so that we can build a listView from that list.
  Future<List<User>> _getOpenConnections() async{
    //ChatService
    /*
    example: for(var doc in snapshot.documents){
                userList.add(User(userName: doc.data["userName"], uid: doc.documentID) (as we stated an open connection document in [Chats] on a user collection is the userID that the user has a connection with
             } ...
             return userList;
     */
  }
}

class NewChatNavigation extends StatelessWidget {
  final List<User> municipal;
  NewChatNavigation({@required this.municipal});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 25, right: 25),
        child: Container(
          width: 63,
          height: 63,
          child: OpenContainer(
            closedColor: Theme.of(context).buttonColor,
            openColor: Theme.of(context).buttonColor,
            closedElevation: 10,
            openElevation: 15,
            closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))
            ),
            transitionType: ContainerTransitionType.fade,
            transitionDuration: const Duration(milliseconds: 450),
            openBuilder: (context, action){
              return NewChatPage(municipalUsers: municipal);
            },
            closedBuilder: (context, action) {
              return Container(
                child: const Icon(Icons.person_add, color: Colors.white,),
                color: Theme.of(context).buttonColor,
              );
            },
          ),
        ),
      ),
    );
  }
}
class ActiveChats extends StatelessWidget {
  final ChatInformation chatInfo;
  ActiveChats(this.chatInfo);
  @override
  Widget build(BuildContext context) {
    double indent = MediaQuery.of(context).size.width * 0.06;
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index){
        return Divider(
          indent: indent,
          endIndent: indent,
        );
      },
        itemCount: chatInfo.openConnections.length,
        itemBuilder: (BuildContext context, int index){
          return UserDisplay(user: chatInfo.openConnections[index]);
        });
  }
}

