import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/addEntryPage.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

class EntryButton extends StatelessWidget {
  final BoardCategory category;
  EntryButton({@required this.category});

  @override
  Widget build(BuildContext context) {
    return
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(bottom: 25, right: 25),
          child: Container(
            width: 63,
            height: 63,
            child: OpenContainer(
              closedColor: Theme.of(context).buttonColor,
              closedElevation: 10.0,
              openElevation: 15.0,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              transitionType: ContainerTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 450),
              openBuilder: (context, action) {
                return AddEntryPage(
                  category: category,
                );
              },
              closedBuilder: (context, action) {
                return Container(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ));
              },
            ),
          ),
        ),
      );
  }
}
