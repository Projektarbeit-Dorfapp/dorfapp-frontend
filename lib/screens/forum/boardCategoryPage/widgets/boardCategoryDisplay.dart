import 'dart:ui';

import 'package:dorf_app/models/boardCategory_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryWithColor{
  final BoardCategory category;
  final Color categoryColor;
  CategoryWithColor(this.category, this.categoryColor);
}
class BoardCategoryDisplay extends StatelessWidget {
  final BoardCategory boardCategory;
  final Color color;
  BoardCategoryDisplay(this.boardCategory, this.color);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        List<dynamic> list = [];
        Navigator.pushNamed(
            context,
            "/boardEntryPage",
            arguments: CategoryWithColor(boardCategory, color));
      },
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: 100,
        decoration: BoxDecoration(

          color: color,
              borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(boardCategory.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: "Raleway"
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
