import 'package:dorf_app/screens/forum/addEntryPage/provider/entryState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///Matthias Maxelon
class AddEntryDescriptionField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entryState = Provider.of<EntryState>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            maxLines: 4,
            maxLength: 500,
            onChanged: (description){
              entryState.setDescription(description);
            },
            validator: (description){
              if(description.isEmpty)
                return "Gib deinem Thema noch eine Beschreibung";
              else return null;
            },
            decoration: const InputDecoration(
              alignLabelWithHint: true,
                labelText: "Beschreibung"
            ),
          ),
        ),
      ],
    );
  }
}
