import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 5.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
              hintText: 'Suche...')
            )
        )
    );
  }
}
