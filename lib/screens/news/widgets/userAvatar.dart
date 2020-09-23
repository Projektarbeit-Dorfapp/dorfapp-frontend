import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class UserAvatar extends StatelessWidget {
  //final String imagePath;
  final String userID;
  final double height;
  final double width;
  UserAvatar({this.height, this.width, this.userID});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _getUser(context),
      builder: (context, snapshot){
        if(snapshot.hasData){
          return Container(
            height: height,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/avatar.png",
                imageCacheHeight: height.round(),
                imageCacheWidth: width.round(),
                image: snapshot.data.imagePath,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace){
                  return placeholder();
                },
                fadeInDuration: const Duration(milliseconds: 100),),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
        } else {
          return placeholder();
        }
      },
    );
  }
  Widget placeholder(){
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        image: const DecorationImage(
          image: const AssetImage("assets/avatar.png"),
          fit: BoxFit.fill,
        ),
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
  Future<User> _getUser(BuildContext context) async{
    User u;
    if(userID != null || userID != ""){
      u = await Provider.of<UserService>(context, listen: false).getUser(userID);
    }
    return u;
  }
}
