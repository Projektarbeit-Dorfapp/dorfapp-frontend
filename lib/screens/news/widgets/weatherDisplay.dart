import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/weather_library.dart';

///Matthias Maxelon
class WeatherDisplay extends StatefulWidget {
  final double textSize;
  WeatherDisplay({this.textSize});
  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  WeatherFactory weatherFactory;
  final mainColor = Colors.black;
  final temperatureColor = Color(0xffdb5656);
  String areaName;
  int temperature;
  Timer updateCycle;
  double lat = 50.05; ///coordinates of desired City
  double lon = 10.2333; ///coordinates of desired City
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
      if(mounted){
        setState(() {
        });
      }
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
          temperature = snapshot.data.temperature.celsius.round();
          areaName = snapshot.data.areaName;
          return Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(areaName,
                    style: TextStyle(color: mainColor, fontSize: widget.textSize != null ? widget.textSize : 16, fontFamily: "Raleway")),
                SizedBox(
                  width: 10,
                ),
                Text(
                  temperature.toString() + "°C",
                  style: TextStyle(
                    fontSize: widget.textSize != null ? widget.textSize : 16,
                    color: _getTemperatureColor(),
                    fontFamily: "Raleway"
                  ),

                ),
                //weatherIcons(),
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
  Widget getBuild(){
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(areaName,
              style: TextStyle(color: mainColor, fontSize: widget.textSize != null ? widget.textSize : 16, fontFamily: "Raleway")),
          SizedBox(
            width: 10,
          ),
          Text(
            temperature.toString() + "°C",
            style: TextStyle(
                fontSize: widget.textSize != null ? widget.textSize : 16,
                color: _getTemperatureColor(),
                fontFamily: "Raleway"
            ),

          ),
          //weatherIcons(),
        ],
      ),
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
  Color _getTemperatureColor(){


    if(temperature >= 20)
      return Color(0xffdb5656);
    else if (temperature <= 0){
      return Colors.blue;
    } else {
      return mainColor;
    }
  }
}
