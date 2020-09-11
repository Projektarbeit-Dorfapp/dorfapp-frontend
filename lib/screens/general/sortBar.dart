import 'package:dorf_app/constants/menu_buttons.dart';
import 'package:flutter/material.dart';


///Matthias Maxelon
class SortBar extends StatelessWidget {
  final Color barColor;
  final double barHeight;
  final double elevation;
  final int commentQuantity;
  final iconColor;
  SortBar({this.barColor, this.barHeight, this.elevation, this.commentQuantity, this.iconColor});

  final double _paddingDistance = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: barHeight != null ? barHeight : 50,
      child: Material(
        elevation: elevation != null ? elevation : 0,
       color: barColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            commentQuantity != null ? Padding(
              padding: EdgeInsets.only(left: _paddingDistance),
              child: Text(
                  commentQuantity.toString() + " Kommentare",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ) : Container(),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: PopupMenuButton(
                icon: Icon(Icons.tune, color: iconColor != null ? iconColor : Theme.of(context).primaryColor,),
                color: Colors.white,
                itemBuilder: (BuildContext context){
                  return MenuButtons.Sorting.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
