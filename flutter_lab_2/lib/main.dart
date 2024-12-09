import 'package:flutter/material.dart';
import 'package:flutter_lab_2/pages/cerrency.dart';
import 'package:flutter_lab_2/pages/length.dart';
import 'package:flutter_lab_2/pages/temperature.dart';
import 'package:flutter_lab_2/pages/time.dart';
import 'package:flutter_lab_2/pages/weight.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: {
        '/main': (context) => MainPage(),
        '/temperature': (context) => TemperaturePage(),
        '/weight': (context) => WeightPage(),
        '/currency': (context) => CurrencyPage(),
        '/length': (context) => LengthPage(),
        '/time': (context) => TimePage()
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Converter"),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/temperature')
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: Text(
                  'Температура',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/weight')
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: Text(
                  'Вес',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/currency')
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: Text(
                  'Валюта',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/length')
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: Text(
                  'Длинна',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => {
                  Navigator.pushNamed(context, '/time')
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 70),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white
                ),
                child: Text(
                  'Время',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}