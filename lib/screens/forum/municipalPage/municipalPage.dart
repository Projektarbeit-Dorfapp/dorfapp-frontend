import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/forum/municipalPage/widgets/userChatDisplay.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MunicipalPage extends StatelessWidget {
  final UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    final indent = MediaQuery.of(context).size.width * 0.1;
    return FutureBuilder<List<User>>(
      future: _getUsers(context),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return ListView.separated(
            separatorBuilder: (context, int index){
              return Divider(
                indent: indent,
                endIndent: indent,
              );
            },
            itemCount: snapshot.data.length,
              itemBuilder: (context, int index){
                return UserDisplay(
                  user: snapshot.data[index],
                );
              });
        } else if (snapshot.hasError){
          return Center(
            child: Text("Etwas ist schief gelaufen"),
          );
        } else { ///waiting for result
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
  Future<List<User>> _getUsers(BuildContext context) async{
    return await _userService.getUsers(await Provider.of<AccessHandler>(context, listen: false).getUser());
  }
}
