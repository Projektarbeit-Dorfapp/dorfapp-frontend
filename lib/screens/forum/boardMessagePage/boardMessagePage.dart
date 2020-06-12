import 'package:dorf_app/models/boardCategory_model.dart';
import 'package:dorf_app/models/boardEntry_Model.dart';
import 'package:flutter/material.dart';

class BoardMessagePage extends StatelessWidget {
  final BoardCategory category;
  final BoardEntry entry;
  BoardMessagePage({@required this.category, @required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Messages in category: ${category.title} and in entry: ${entry.title}"),
      ),
    );
  }
}
