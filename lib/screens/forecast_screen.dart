import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:assignment2/screens/detailed_screen.dart';

class ForecastScreen extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> forecast;

  const ForecastScreen(
      {Key? key, required Future<List<Map<String, dynamic>>> this.forecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Forecast'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: forecast,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    developer.log(snapshot.data.toString(),
                        name: 'history unit data');
                    developer.log(snapshot.data.runtimeType.toString(),
                        name: 'history unit type');
                    developer.log(snapshot.data!.elementAt(0).toString(),
                        name: 'history unit sample');
                    return _HistoryUnit(
                        snapshot.data!.elementAt(index), context);
                  },
                )
              : Container(
                  child: Text('No data'),
                );
        },
      ),
    );
  }

  Widget _HistoryUnit(Map<String, dynamic> forecastUnit, BuildContext context) {
    developer.log('entered history unit');
    final Map<String, dynamic> dayData = forecastUnit['day'];
    final List<dynamic> hourlyData = forecastUnit['hour'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return DetailedScreen(hourlyData: hourlyData, dayData: dayData);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: Colors.black38,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                forecastUnit['date'].toString(),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: _DataUnit(
                'avgtemp_c',
                dayData['avgtemp_c'].toString(),
                Icon(Icons.thermostat),
              ),
            ),
            Expanded(
              child: _DataUnit(
                'condition',
                dayData['condition']['text'].toString(),
                Icon(Icons.terrain),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _DataUnit(String desc, String val, Icon logo) {
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          logo,
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            val,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
