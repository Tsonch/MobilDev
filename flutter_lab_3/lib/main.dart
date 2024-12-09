import 'package:flutter/material.dart';
import 'package:flutter_lab_3/pages/add.dart';
import 'package:flutter_lab_3/pages/edit.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: {
        '/main' : (context) => MainPage(),
        '/add' : (context) => AddPage(),
        '/edit' : (context) => EditPage()
      },
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

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo',
        style: TextStyle(
          color: Colors.white
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center( 
          child: Column (
            children: [
              
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.pushNamed(context, '/add')
        },
        tooltip: 'Добавить',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
