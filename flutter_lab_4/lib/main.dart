import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'main',
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime currentDate = DateTime.now();
  final weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text("Calendar", 
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 55,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back, 
                        color: Colors.white,
                      ),
                      onPressed: () => {}
                    ),
                    // Text(
                    //   DateFormat.yMMMM().format(),
                    //   style: const TextStyle(fontSize: 20),
                    // ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () => {}
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 7,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(7, (index) {
                return Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                );
              }),
            ),
            
          ],
        ),
      ),
    );
  }
}
