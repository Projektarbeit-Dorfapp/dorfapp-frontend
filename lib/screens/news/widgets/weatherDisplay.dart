import 'dart:async';
import 'package:dorf_app/models/user_model.dart';
import 'package:dorf_app/screens/login/loginPage/provider/accessHandler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

///Matthias Maxelon
class WeatherDisplay extends StatefulWidget {
  final double textSize;
  WeatherDisplay({this.textSize});
  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation;
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
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
    final access = Provider.of<AccessHandler>(context, listen: false);
    User u = await access.getUser();
    return await weatherFactory.currentWeatherByCityName(u.municipalReference);
  }
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: initializeWeatherData(),
      builder: (BuildContext context, AsyncSnapshot<Weather> snapshot){
        if(snapshot.hasData){
          _controller.forward();
          temperature = snapshot.data.temperature.celsius.round();
          areaName = snapshot.data.areaName;
          return FadeTransition(
            opacity: _animation,
            child: Padding(
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
            ),
          );
        }
        else if(snapshot.hasError){
          return Container();
        } else {
          return Container();
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
