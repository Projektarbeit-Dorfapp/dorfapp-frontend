import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEntryTitleField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entryState = Provider.of<EntryState>(context, listen: false);
    return TextFormField(
      onChanged: (value){
        entryState.title = value;
      },
      decoration: const InputDecoration(
          labelText: "Titel"
      ),
    );
  }
}
