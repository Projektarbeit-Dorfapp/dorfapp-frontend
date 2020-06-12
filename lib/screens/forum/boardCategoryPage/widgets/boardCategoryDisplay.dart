import 'package:dorf_app/models/boardCategory_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BoardCategoryDisplay extends StatelessWidget {
  final BoardCategory boardCategory;
  BoardCategoryDisplay(this.boardCategory);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(
            context,
            "/boardEntryPage",
            arguments: boardCategory);
      },
      child: Container(
        height: 60,
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(boardCategory.title,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: "Raleway"
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
