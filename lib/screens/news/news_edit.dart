import 'dart:io';

import 'package:dorf_app/screens/news/news_detail.dart';
import 'package:dorf_app/models/address_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dorf_app/services/news_service.dart';
import 'package:dorf_app/models/news_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

//Hannes Hauenstein

class NewsEdit extends StatefulWidget {

  final String newsID;
  const NewsEdit([this.newsID]);

  @override
  _NewsEditState createState() => _NewsEditState();
}

class _NewsEditState extends State<NewsEdit> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _districtController = TextEditingController();
  final _streetController = TextEditingController();
  final _newsService = NewsService();

  News news = new News();
  Address address = new Address();


  File _image;
  String _uploadedFileURL;
  final f = new DateFormat('dd.MM.yyyy HH:mm');
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now();
  bool isNews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF6178a3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit News'),
      ),
      body: StreamBuilder<Object>(
        stream: Firestore.instance.collection("Veranstaltung").snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  child: _image == null
                      ? Center(
                          child: InkWell(
                            child: Container(
                                child: Image.asset('assets/placeholder.png')
                            ),
                            onTap: () {
                              _pickImage();
                            },
                          ),
                        )
                      : Center(
                          child: Image.file(_image, fit: BoxFit.cover),
                        ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Start: ' + f.format(startDateTime)),
                        onTap:  () {
                          DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                            }, onConfirm: (date) {
                            setState(() {
                              startDateTime = date;
                            });
                            }, currentTime: DateTime.now(), locale: LocaleType.de);
                          },
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                      ListTile(
                        title: Text('Ende: ' +  f.format(endDateTime)),
                        onTap:  () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2022, 6, 7), onChanged: (date) {
                              }, onConfirm: (date) {
                                setState(() {
                                  endDateTime = date;
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.de);
                        },
                        trailing: Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: const Text('News?'),
                          value: isNews,
                          onChanged: (bool newValue) {
                            setState(() {
                              isNews = newValue;
                            });
                            print(newValue);
                            print(isNews);
                          },
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                              hintText: 'Titel eingeben', labelText: 'Titel'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Bitte einen Titel eingeben';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: 'Beschreibung eingeben',
                              labelText: 'Beschreibung'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Beschreibung eingeben';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: 4,
                              child: TextFormField(
                                controller: _streetController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    hintText: 'Straßennamen eingeben',
                                    labelText: 'Straßennamen'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Straßennamen eingeben';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: TextFormField(
                                controller: _houseNumberController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                    hintText: 'Hausnummer eingeben',
                                    labelText: 'Hausnummer'),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Hausnummer eingeben';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _zipCodeController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: 'Postleitzahl eingeben',
                              labelText: 'Postleitzahl'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Postleitzahl eingeben';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _districtController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: 'Ort eingeben',
                              labelText: 'Ort'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Ort eingeben';
                            }
                            return null;
                          },
                        ),                        
                        _addNewsButton(widget.newsID),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
  Future _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    uploadFile();
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(new DateTime.now().millisecondsSinceEpoch.toString() + _image.path.split("/")?.last);
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  RaisedButton _addNewsButton(String newsID) {
    AccessHandler _accessHandler = Provider.of<AccessHandler>(context, listen: false);
    if (newsID != null){
      return RaisedButton(
        child: Text('Aktualisieren'),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            news.title = _titleController.text;
            news.description = _descriptionController.text;
            address.district = _districtController.text;
            address.houseNumber = _houseNumberController.text;
            address.street = _streetController.text;
            address.zipCode = _zipCodeController.text;
            news.address = address;
            news.startTime = Timestamp.fromDate(startDateTime);
            news.endTime = Timestamp.fromDate(endDateTime);
            news.isNews = this.isNews;
            news.createdBy = await _accessHandler.getUID();
            ///Noch eigene Funktion 'updateNews' draus machen
            news.imagePath = _uploadedFileURL;
            _newsService.insertNews(news);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetail(newsID)));
          }
        },
      );
    }
    else {
      return RaisedButton(
        child: Text('Erstellen'),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            news.title = _titleController.text;
            news.description = _descriptionController.text;
            address.district = _districtController.text;
            address.houseNumber = _houseNumberController.text;
            address.street = _streetController.text;
            address.zipCode = _zipCodeController.text;
            news.address = address;
            news.startTime = Timestamp.fromDate(startDateTime);
            news.endTime = Timestamp.fromDate(endDateTime);
            news.isNews = this.isNews;
            news.createdBy = await _accessHandler.getUID();
            news.imagePath = _uploadedFileURL;
            _newsService.insertNews(news);
          }
        },
      );
    }
  }
}