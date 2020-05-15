import 'dart:io';

import 'package:dorf_app/basic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewsEdit extends StatefulWidget {
  @override
  _NewsEditState createState() => _NewsEditState();
}

class _NewsEditState extends State<NewsEdit> {
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit News'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: _image == null
                  ? Center(
                      child: RaisedButton(
                        child: Text('Select an Image ',
                            style: Theme.of(context).textTheme.headline2),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    )
                  : Center(
                      child: Image.file(_image, fit: BoxFit.cover),
                    ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Titel eingeben',
                        labelText: 'Titel'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Bitte einen Titel eingeben';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Beschreibung eingeben',
                          labelText: 'Beschreibung'
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Beschreibung eingeben';
                        }
                        return null;
                      },
                    ),
                    RaisedButton(
                      child: Text('Erstellen'),
                      onPressed: () {
                        if(_formKey.currentState.validate())
                          {
                            print("Working");
                          }
                        print('Titel: ' + _titleController.text + ' Beschreibung: ' +_descriptionController.text);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
