import 'package:dorf_app/models/address_model.dart';
import 'package:flutter/cupertino.dart';

class NewsModel{

  //no need for zip code ?
  final String title;
  final String description;
  final String startTime;
  final String endTime; //missing in data model
  final String startDate;
  final String endDate;
  final Address address;
  final String imagePath;

  NewsModel(this.title, this.description, this.startTime, this.endTime, this.startDate, this.endDate, this.address, this.imagePath);

}