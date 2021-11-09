import 'package:flutter/material.dart';
import 'package:assignment2/endpoints/weather.endpoint.dart';
import 'package:assignment2/screens/detailed_screen.dart';
import 'package:assignment2/screens/forecast_screen.dart';
import 'package:assignment2/screens/home_screen.dart';

void main() {
  //WeatherAPI api = WeatherAPI();
  //api.realtime(null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework 2',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
