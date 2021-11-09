import 'package:flutter/material.dart';
import 'package:assignment2/endpoints/weather.endpoint.dart';

class DetailedScreen extends StatelessWidget {
  final List<dynamic> hourlyData;
  final Map<String, dynamic> dayData;
  const DetailedScreen(
      {Key? key,
      required List<dynamic> this.hourlyData,
      required Map<String, dynamic> this.dayData})
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
        title: Text('Hourly'),
      ),
      body: ListView.builder(
          itemCount: hourlyData.length,
          itemBuilder: (context, index) {
            return _HistoryUnit(hourlyData.elementAt(index) as Map);
          }),
    );
  }

  Widget _HistoryUnit(Map data) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              "Time \n\n${data['time']}",
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.wb_sunny),
              'max temp',
              dayData['maxtemp_c'].toString(),
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.ac_unit),
              'min temp',
              dayData['mintemp_c'].toString(),
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.thermostat),
              'avg temp',
              dayData['avgtemp_c'].toString(),
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.air),
              'max wind kph',
              dayData['maxwind_kph'].toString(),
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.cloud),
              'total prec',
              dayData['totalprecip_mm'].toString(),
            ),
          ),
          Expanded(
            child: _DataUnit(
              Icon(Icons.terrain),
              'condition',
              dayData['condition']['text'].toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _DataUnit(Icon logo, String desc, String val) {
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          logo,
          Text(
            desc,
            textAlign: TextAlign.center,
          ),
          Text(
            val,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
