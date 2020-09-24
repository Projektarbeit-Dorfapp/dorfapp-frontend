import 'package:dorf_app/models/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Meike Nedwidek
class DeleteComment extends StatelessWidget {
  final Function onDelete;
  final Function onCancel;
  final double containerSize;

  DeleteComment(this.onDelete, this.onCancel, this.containerSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width - containerSize,
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Text("Löschen", style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                ],
              ),
              onTap: () {
                onDelete();
              }),
          GestureDetector(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Text("Abbrechen", style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white))
              ],
            ),
            onTap: () {
              onCancel();
            },
          ),
        ],
      ),
    );
  }
}
