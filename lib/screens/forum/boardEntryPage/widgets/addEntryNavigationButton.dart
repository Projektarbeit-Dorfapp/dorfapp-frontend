import 'package:animations/animations.dart';
import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/screens/forum/addEntryPage/addEntryPage.dart';
import 'package:flutter/material.dart';

class AddEntryNavigationButton extends StatelessWidget {
  final BoardCategory category;
  final Color categoryColor;
  AddEntryNavigationButton({@required this.category, @required this.categoryColor});
  final _formKey = GlobalKey<FormState>();
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
              closedColor: categoryColor,
              closedElevation: 10.0,
              openElevation: 15.0,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              transitionType: ContainerTransitionType.fade,
              transitionDuration: const Duration(milliseconds: 450),
              openBuilder: (context, action) {
                return AddEntryPage(
                  categoryColor: categoryColor,
                  category: category,
                  formKey: _formKey,
                );
              },
              closedBuilder: (context, action) {
                return Container(
                    child: const Icon(
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
