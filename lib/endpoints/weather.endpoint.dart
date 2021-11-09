import 'dart:convert';
import 'dart:developer' as developer;

import 'package:assignment2/environment.dart';
import 'package:http/http.dart' as http;
import 'package:assignment2/utils/date.utils.dart';

class WeatherAPI {
  static final WeatherAPI singleton = WeatherAPI._internal();
  static final String base = 'http://api.weatherapi.com/v1';
  static final DateUtil dateUtil = DateUtil();
  final String key = Environment.key;

  factory WeatherAPI() {
    return singleton;
  }

  WeatherAPI._internal();

  Future<Map<String, dynamic>> realtime(String? city) async {
    String currentLocation = 'ip:auto';
    developer.log(currentLocation.toString(), name: 'Current Location');
    String loc = (city == null) ? currentLocation : city;
    Uri url = Uri.parse('$base/current.json?key=$key&q=$loc&aqi=yes');
    final response = await http.get(url);

    developer.log(url.toString(), name: 'URL');
    developer.log(response.statusCode.toString(), name: 'statusCode');
    developer.log(jsonDecode(response.body).toString(), name: 'response body');
    if (response.statusCode ~/ 100 == 2) {
      developer.log('data fetched', name: 'indicate fetch');
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      developer.log('decoded', name: 'success decoding');
      developer.log(json['location']['region'].toString(),
          name: 'log realtime fetch');
      return json;
    } else {
      throw Exception('Sussius Maximus');
    }
  }

  Future<List<Map<String, dynamic>>> history(String? city) async {
    String loc = (city == null) ? 'ip:auto' : city;
    String yesterday = dateUtil.StringifyYesterday();
    Uri url = Uri.parse('$base/history.json?key=$key&q=$loc&dt=$yesterday');
    developer.log(url.toString(), name: 'History URL');
    final response = await http.get(url);
    developer.log(response.body.toString(), name: 'History Response');
    List<Map<String, dynamic>> list = [];

    if (response.statusCode ~/ 100 == 2) {
      developer.log('status code 200', name: 'history status code');
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      developer.log(json.toString(), name: 'history decoded');
      developer.log(json['forecast']['forecastday'][0]['hour'][0].toString(),
          name: 'history sample');
      list.add(json['forecast']['forecastday'][0]['hour'][0]);
      list.add(json['forecast']['forecastday'][0]['hour'][11]);
      list.add(json['forecast']['forecastday'][0]['hour'][23]);
      developer.log(list.toString(), name: 'history output');
      return list;
    } else {
      throw Exception('Sussius Maximus');
    }
  }

  Future<List<Map<String, dynamic>>> forecast(String? city) async {
    String loc = (city == null) ? 'ip:auto' : city;
    Uri url = Uri.parse('$base/forecast.json?key=$key&q=$loc&days=3');
    final response = await http.get(url);
    List<Map<String, dynamic>> list = [];
    developer.log(response.statusCode.toString(), name: 'forecast status code');
    developer.log(response.body.toString(), name: 'forecast content');

    if (response.statusCode ~/ 100 == 2) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      developer.log(json['forecast']['forecastday'][1].toString(),
          name: 'forecast direct sample');
      developer.log(json['forecast']['forecastday'].length.toString(),
          name: 'all forecasts');
      list.add(json['forecast']['forecastday'][0]);
      list.add(json['forecast']['forecastday'][1]);
      list.add(json['forecast']['forecastday'][2]); //day and hour
      developer.log(list.toString(), name: 'forecast sample output');
      return list;
    } else {
      throw Exception('Sussius Maximus');
    }
  }
}
