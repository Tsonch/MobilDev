import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:WeatherApp/models/weather_model.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WheatherApp',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 58, 165, 219),
      ),
      home:  MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Wheather? _wheather;

  bool isLoad = true;
  List<String> cities = ["Moscow", "Surgut", "Ekaterinburg", "Nyagan", "Khanty-Mansiysk", "Saint-Petrsburg"];
  
  @override
  void initState() {
    super.initState();
    getWheather();
  }

  String city = "Moscow";
  final String key = "876cbf6c26714be1a0d85619241212";
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<void> getWheather() async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$key&q=$city&days=5');
    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      _wheather = Wheather.fromJson(json);
      setState(() {
        isLoad = false;
      });
    }
    else {
      setState(() {
        isLoad = false;
      });
      throw Exception(resp.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WheatherApp'),
        backgroundColor: Colors.blueAccent,
      ),
      body:
        isLoad ? Center(child: Text("Пожалуста подождите", style: TextStyle(fontSize: 28),),) :
        Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 213, 255),
                borderRadius: BorderRadius.circular(10)
              ),
              alignment: AlignmentDirectional.center,
              child: TextButton(
                onPressed: () => {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(cities[index], 
                                style: TextStyle(
                                  fontSize: 20
                                ),
                              ),
                              onTap: () => {
                                setState(() {
                                  city = cities[index];
                                  getWheather();
                                }),
                                Navigator.pop(context)
                              },
                            );
                          }
                        ),
                      );
                    }
                  )
                },
                child: Text(city, 
                  style: TextStyle(
                  fontSize: 28,
                  color: Colors.black
                ),
              ),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 213, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text("Today",
                        style: TextStyle(
                          fontSize: 25
                        ),
                      ),
                    ),
                    Text(_wheather!.forecast[0].date, 
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Image.network(
                        'http:' + _wheather!.forecast[0].icon,
                        scale: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(_wheather!.currentTemp, 
                        style: TextStyle(
                          fontSize: 26
                        ),
                      ),
                    ),
                    Text(
                      _wheather!.forecast[0].condition + " " + 
                          (_wheather!.forecast[0].maxTemp).toString() + "/" + (_wheather!.forecast[0].minTemp).toString(),
                      style: TextStyle(
                        fontSize: 22
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 213, 255),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: 
                  List<Widget>.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 70,
                        child: Center(
                          child: Column(
                            children: [
                              Image.network(
                                'http:' + _wheather!.forecast[index + 1].icon, 
                                scale: 0.8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  _wheather!.forecast[index + 1].condition,
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  (_wheather!.forecast[index + 1].maxTemp).toString() + "/" 
                                    + (_wheather!.forecast[index + 1].minTemp).toString(),
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  _wheather!.forecast[index + 1].date,
                                  style: TextStyle(
                                    fontSize: 13
                                  ),
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                    );
                  }),
              ),
            ),
          )
        ],
      )
    );
  }
}
