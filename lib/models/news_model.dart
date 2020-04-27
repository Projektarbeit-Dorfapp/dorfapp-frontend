import 'package:flutter/cupertino.dart';

class NewsModel{

  final String title;
  final String description;
  final String beginning;
  final String end; //missing in data model
  final String date;
  final String zipCode;
  final String district;
  final String houseNumber;
  final String buildingId;

  NewsModel(this.title, this.description, this.beginning, this.end, this.date, this.zipCode, this.district, this.houseNumber, this.buildingId);

}