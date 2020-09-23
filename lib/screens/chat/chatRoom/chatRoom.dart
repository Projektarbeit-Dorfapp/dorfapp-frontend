import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/chat/chatRoom/provider/chatMessageHandler.dart';
import 'package:dorf_app/screens/chat/chatRoom/provider/partnerOnlineState.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/messageStream.dart';
import 'package:dorf_app/screens/chat/chatRoom/widgets/sendMessageField.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/screens/news/widgets/userAvatar.dart';
import 'package:dorf_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class ChatRoom extends StatefulWidget {
  final User selectedUser;
  final String chatID; /// can be null
  final String role; ///can be null
  ChatRoom({@required this.selectedUser, @required this.chatID,  this.role});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver{
  ChatService chatS;
  User _loggedUser;
  String _currentRole;

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    chatS = ChatService();
    if(widget.role != null){
       _currentRole = widget.role;
       _initiateLoggedUserData();
    } else{
      chatS.findRoleOfSelectedUser(widget.selectedUser, widget.chatID).then((selectedUserRole){
        if(selectedUserRole != ""){
          _currentRole = _getClientRole(selectedUserRole);
          _initiateLoggedUserData();
        } else{
          _currentRole = "creator"; ///if there is no role defined it means there is no existing chat, the client would always be the creator then
          _initiateLoggedUserData();
        }
      });
    }
    super.initState();
  }
  _initiateLoggedUserData(){
    Provider.of<AccessHandler>(context, listen: false).getUser().then((value){
      if(mounted){
        setState(() {
          _loggedUser = value;
          _goOnline();
        });
      }
    }).catchError((error){
      debugPrint(error.toString());
    });
  }
  _goOnline(){
    if(widget.chatID != null)
      chatS.goOnline(_loggedUser, widget.selectedUser, widget.chatID, _currentRole);
  }

  String _getClientRole(String selectedUserRole){
    String clientRole = "";
    switch(selectedUserRole){
      case("partner"):
        clientRole = "creator";
        break;
      case("creator"):
        clientRole = "partner";
        break;
      default:
        break;
    }
    return clientRole;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context){
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                UserAvatar(height: 40, width: 40, userID: widget.selectedUser.uid,),
                Flexible(
                  child: ChangeNotifierProvider(
                    create: (context) => PartnerOnlineState(widget.chatID),
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text( "${widget.selectedUser.firstName} ${widget.selectedUser.lastName}",
                              overflow: TextOverflow.ellipsis,),
                          ),
                          Consumer<PartnerOnlineState>(
                            builder: (context, partnerOnlineState, _){
                              return Text(partnerOnlineState.getPartnerOnlineState(_currentRole),
                              style: TextStyle(
                                fontSize: 11
                              ),);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: _loggedUser != null && _currentRole != null ? ChangeNotifierProvider(
              create: (context) => ChatRoomHandler(widget.chatID, _currentRole, _loggedUser, widget.selectedUser),
            child: Column(
              children: [
                Consumer<ChatRoomHandler>(
                  builder: (context, chatMessageHandler, _){
                    return chatMessageHandler.chatRoomID != null && chatMessageHandler.role != null ? MessageStream(_loggedUser, chatMessageHandler.chatRoomID) : Expanded(child: Container());
                  },
                ),
                SizedBox(height: 5,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ChatMessageTextField(chatRoomID: widget.chatID, selectedUser: widget.selectedUser),
                ),
              ],
            ),
          ) : Center(
            child: CircularProgressIndicator(),
          )
        );
      },
    );
  }
}




