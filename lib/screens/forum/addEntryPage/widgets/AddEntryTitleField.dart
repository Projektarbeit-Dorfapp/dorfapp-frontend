import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AddEntryTitleField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entryState = Provider.of<EntryState>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            maxLength: 100,
            onChanged: (title){
              entryState.title = title;
            },
            validator: (title){
              if(title.isEmpty)
                return "Gib deinem Thema einen Titel";
              else return null;
            },
            decoration: const InputDecoration(
                labelText: "Titel",
            ),
          ),
        ),
      ],
    );
  }
}
