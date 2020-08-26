import 'package:dorf_app/models/chatMessage_model.dart';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/newChat/provider/chatSearch.dart';
import 'package:dorf_app/screens/chat/newChat/widgets/searchField.dart';
import 'package:dorf_app/screens/chat/newChat/widgets/userChatDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class NewChatPage extends StatelessWidget {
  final List<User> municipalUsers;
  NewChatPage({@required this.municipalUsers});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatSearch(municipalUsers),
      child: Scaffold(
        appBar: NewChatSearchAppBar(
          maxUsers: municipalUsers.length,
        ),
        body: NewChatUserList(),
      ),
    );
  }
}

class NewChatUserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatSearch>(
      builder: (context, chatSearch, _) {
        return ListView.builder(
          itemCount: chatSearch.searchLength,
          itemBuilder: (BuildContext context, int index) {
            User u = chatSearch.getSearchedUsers()[index];
            return NewUserChatDisplay(
              user: u,
            );
          },
        );
      },
    );
  }
}

class NewChatSearchAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  NewChatSearchAppBar({Key key, @required this.maxUsers})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);
  @override
  final Size preferredSize;
  final int maxUsers;
  @override
  _NewChatSearchAppBarState createState() => _NewChatSearchAppBarState();
}

class _NewChatSearchAppBarState extends State<NewChatSearchAppBar> {
  bool _showSearch = false;
  @override
  Widget build(BuildContext context) {
    return _showSearch == false
        ? AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text("Dorfmitglied wählen"),
                Text(
                  widget.maxUsers.toString() + " Mitglieder",
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _showSearch = true;
                  });
                },
              ),
            ],
          )
        : AppBar(
            backgroundColor: Colors.white,
            leading: Container(),
            title: SearchField(),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    Provider.of<ChatSearch>(context, listen: false).clear();
                    _showSearch = false;
                  });
                },
              ),
            ],
          );
  }
}
