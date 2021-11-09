import 'package:flutter/material.dart';
import 'package:assignment2/endpoints/weather.endpoint.dart';
import 'dart:developer' as developer;

import 'package:assignment2/screens/forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  late TextEditingController searchBarController;
  WeatherAPI api = WeatherAPI();
  late Future<Map<String, dynamic>> result;
  late Future<List<Map<String, dynamic>>> history;
  late Future<List<Map<String, dynamic>>> forecast;

  @override
  void initState() {
    super.initState();
    searchBarController = TextEditingController();
    callAPI(null);
    developer.log(result.toString(), name: 'realtime result');
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching ? _SearchBar() : const Text('assignment2'),
        actions: <Widget>[
          (isSearching
              ? Container()
              : SafeArea(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                    icon: Icon(Icons.search),
                  ),
                )),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: history,
        builder: (context, snapshot) {
          List<Map<String, dynamic>>? data = snapshot.data;
          return snapshot.hasData
              ? _Content(data!)
              : Container(
                  child: Text('Unable to Connect'),
                );
        },
      ),
    );
  }

  ListView _Content(List<Map<String, dynamic>> data) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 8),
          child: FutureBuilder<Map<String, dynamic>>(
            future: result,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Text(
                      (snapshot.data)!['location']['region'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                  : Text(
                      'Somewhere',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    );
            },
          ),
        ),
        _FatCard(result),
        Container(
          padding: EdgeInsets.only(
            bottom: 8,
          ),
          child: Text(
            'Yesterday (History)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        _HistoryUnit(
          historyData: data[0],
        ),
        _HistoryUnit(
          historyData: data[1],
        ),
        _HistoryUnit(
          historyData: data[2],
        ),
        // _HistoryUnit(),
        // _HistoryUnit(),
        // _HistoryUnit(),
      ],
    );
  }

  Widget _SearchBar() {
    return Stack(
      children: <Widget>[
        TextField(
          controller: searchBarController,
          decoration: InputDecoration(
            hintText: 'Type in a city name...',
            border: OutlineInputBorder(),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    callAPI(searchBarController.text);
                  });
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = false;
                  });
                },
                icon: Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void callAPI(String? region) {
    result = api.realtime(region);
    history = api.history(region);
    forecast = api.forecast(region);
  }

  Widget _FatCard(Future<Map<String, dynamic>> realtimeData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: Colors.black38,
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: realtimeData,
          builder: (context, snapshot) {
            Map<String, dynamic>? data = snapshot.data;
            developer.log(data.toString(), name: 'possible data');
            Map<String, dynamic> placeholder = {
              'current': {
                'wind_kph': 'data',
                'pressure_mb': 'data',
                'precip_mm': 'data',
                'humidity': 'data',
                'cloud': 'data',
                'gust_kph': 'data',
                'condition': 'data',
                'temp_c': 'data',
                'last_updated': 'data'
              }
            };
            return snapshot.hasData
                ? _CardBottom(data!)
                : Container(
                    child: Text(
                      'No connection',
                    ),
                  );
          },
        ),
      ),
    );
  }

  Column _CardBottom(Map<String, dynamic> data) {
    developer.log(data.toString(), name: 'realtimeData');
    return Column(
      children: <Widget>[
        Container(
          height: 160,
          child: GridView.count(
            crossAxisCount: 4,
            children: <Widget>[
              _CardDataUnit(
                descriptor: 'wind kph',
                val: data['current']['wind_kph'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'pressure mb',
                val: data['current']['pressure_mb'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'precip mm',
                val: data['current']['precip_mm'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'humidity',
                val: data['current']['humidity'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'cloud',
                val: data['current']['cloud'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'gust kph',
                val: data['current']['gust_kph'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'condition',
                val: data['current']['condition']['text'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'temp c',
                val: data['current']['temp_c'].toString(),
              ),
              _CardDataUnit(
                descriptor: 'co',
                val: data['current']['air_quality']['co'].round().toString(),
              ),
              _CardDataUnit(
                descriptor: 'no2',
                val: data['current']['air_quality']['no2'].round().toString(),
              ),
              _CardDataUnit(
                descriptor: 'o3',
                val: data['current']['air_quality']['o3'].round().toString(),
              ),
              _CardDataUnit(
                descriptor: 'so2',
                val: data['current']['air_quality']['so2'].round().toString(),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                        'Last Updated: \n${data['current']['last_updated'].toString()}'),
                  ),
                  Expanded(
                    child: IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ForecastScreen(forecast: forecast);
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.remove_red_eye),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}

class _HistoryUnit extends StatelessWidget {
  final Map<String, dynamic> historyData;

  const _HistoryUnit({
    Key? key,
    required Map<String, dynamic> this.historyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 6,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 90,
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Text(
                    historyData['time'].toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
                _DataUnit(
                  logo: Icon(Icons.thermostat),
                  descriptor: 'temp c',
                  val: historyData['temp_c'].toString(),
                ),
                _DataUnit(
                  logo: Icon(Icons.terrain),
                  descriptor: 'condition',
                  val: historyData['condition']['text'].toString(),
                ),
                _DataUnit(
                  logo: Icon(Icons.air),
                  descriptor: 'humidity',
                  val: historyData['humidity'].toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataUnit extends StatelessWidget {
  final Icon logo;
  final String descriptor;
  final String val;

  const _DataUnit({
    Key? key,
    Icon this.logo = const Icon(Icons.ac_unit),
    required String this.descriptor,
    required String this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: logo,
          ),
          Flexible(
            child: Column(
              children: <Widget>[
                Text(
                  descriptor,
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
          )
        ],
      ),
    );
  }
}

class _CardDataUnit extends StatelessWidget {
  final String descriptor;
  final String val;

  const _CardDataUnit({
    Key? key,
    required String this.descriptor,
    required String this.val,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 25,
        ),
        Flexible(
          child: Column(
            children: <Widget>[
              Text(
                descriptor,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                val,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
