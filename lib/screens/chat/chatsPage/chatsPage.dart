import 'package:animations/animations.dart';
import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatsPage/provider/openConnectionState.dart';
import 'package:dorf_app/screens/chat/chatsPage/widgets/userChatDisplay.dart';
import 'package:dorf_app/screens/chat/newChat/newChatPage.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfo{
  List<User> municipalUsers;
  User loggedUser;
UserInfo({this.municipalUsers, this.loggedUser});
}
class Chats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Dorf App'),
          centerTitle: true,
        ),
      body: FutureBuilder(
        future: _getInitialData(context),
        builder: (context, AsyncSnapshot<UserInfo> municipalUsers){
          if(municipalUsers.hasData){
            return StreamBuilder<List<OpenChat>>(
              stream: ChatService().getOpenConnectionsAsStream(municipalUsers.data.loggedUser),
              builder: (context, openConnections) {


                if(openConnections.hasData){
                  Provider.of<OpenConnectionState>(context, listen: false).setOpenConnections(openConnections.data); /// fill list with openConnections
                  return Stack(
                    children: [
                      ActiveChats(),
                      NewChatNavigation(municipal: municipalUsers.data.municipalUsers)
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            );
          }
          else if (municipalUsers.connectionState == ConnectionState.waiting){
            return Container();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
  
  List<User> getUnique(List<User> user, List<OpenChat> openChats){
    List<User> newList = [];
    newList.addAll(user);
    newList.addAll(openChats.whereType<User>());
    Map<User, int> map = Map();
    newList.forEach((element) {
      if(!map.containsKey(element)){
        map[element] = 1;
      } else{
        map[element] += 1;
      }
    });
    map.removeWhere((key, value) => value > 1);
    List<User> anotherNewList = [];
    map.forEach((key, value) {
      anotherNewList.add(key);
    });
    return anotherNewList;

  }

  Future<UserInfo> _getInitialData(BuildContext context) async{
    final userS = Provider.of<UserService>(context, listen: false);
    final access = Provider.of<AccessHandler>(context, listen: false);

    List<User> municipalUsers = await userS.getUsers(await access.getUser());

    return UserInfo(
      municipalUsers: municipalUsers,
      loggedUser: await access.getUser()
    );
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
  @override
  Widget build(BuildContext context) {
    double indent = MediaQuery.of(context).size.width * 0.06;
    final openConnections = Provider.of<OpenConnectionState>(context, listen: false);
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index){
        return Divider(
          indent: indent,
          endIndent: indent,
        );
      },
        itemCount: openConnections.getOpenConnections().length,
        itemBuilder: (BuildContext context, int index){
          return UserDisplay(openChat: openConnections.getOpenConnections()[index]);
        });
  }
}

