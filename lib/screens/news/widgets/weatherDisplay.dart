import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';


class WeatherDisplay extends StatefulWidget {
  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherFactory weatherFactory;
  final mainColor = Colors.black;
  final temperatureColor = Color(0xffdb5656);
  Timer updateCycle;
  double lat = 50.05; //coordinates of desired City
  double lon = 10.2333; //coordinates of desired City
  @override
  void initState() {
    super.initState();
    weatherFactory = WeatherFactory("c2c10f74ba4dcdbdcf10250640a08187");
    updateState();
  }
  @override
  void dispose() {
    super.dispose();
    updateCycle.cancel();
  }
  updateState() {
    final int waitTime = 30;
    updateCycle = Timer.periodic(Duration(minutes: waitTime), (Timer t) {
      setState(() {
      });
    });
  }
  Future<Weather> initializeWeatherData() async {
    return await weatherFactory.currentWeatherByLocation(lat, lon);
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: initializeWeatherData(),
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot){
        if(snapshot.hasData){
          return Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(snapshot.data.areaName,
                    style: TextStyle(color: mainColor, fontSize: 16, fontFamily: "Raleway")),
                SizedBox(
                  width: 10,
                ),
                Text(
                  snapshot.data.temperature.celsius.round().toString() + "°C",
                  style: TextStyle(
                    fontSize: 16,
                    color: temperatureColor,
                    fontFamily: "Raleway"
                  ),

                ),
                weatherIcons(),
              ],
            ),
          );
        }
        else if(snapshot.hasError){
          return Container();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  Widget weatherIcons(){
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Icon(Icons.wb_sunny, color: Colors.orangeAccent),
          ),
          Align(
            alignment: Alignment.center,
            child: Icon(Icons.wb_cloudy, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
