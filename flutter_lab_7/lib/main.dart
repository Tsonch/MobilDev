import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:News/model/news_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

void main() async {

  await Hive.initFlutter();
  await Hive.openBox('NewsBox');

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: ThemeData(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool isLoad = false;
  bool isSorted = true;
  late bool hasInternet;
  List news = [];
  List<String> categories = ["All", "travel", "food", "technology", "politics", "business"];
  String selectedCategory = "All";
  DateTime? selectedDate;
  
  final newsBox = Hive.box("NewsBox");

  Future<void> fetchNews({String? category, DateTime? date}) async {

    isLoad = true;

    String apiKey = "5LQCggnDc-dxJXBOBdKpsbO0Fl7DQmoWoko8ihnwuaKu1oQp";
    String apiUrl = "https://api.currentsapi.services/v1/latest-news?apiKey=$apiKey";

    if (category != null || date != null) {
      apiUrl = "https://api.currentsapi.services/v1/search?apiKey=$apiKey";
    }
    if (category != null) {
      apiUrl += '&category=$category';
    }
    if (date != null) {
      final formattedDateStart = date.toIso8601String() + "Z";
      final formattedDateEnd = date.add(Duration(hours: 23, minutes: 59, seconds: 59)).toIso8601String() + "Z";
      apiUrl += '&start_date=$formattedDateStart&end_date=$formattedDateEnd';
    }

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          news = (json['news'] as List).map((el) => News.fromJson(el)).toList();
          isLoad = false;
          newsBox.add(json['news']);
        });
      }
    }
    catch (exception) {
      setState(() {
        isLoad = false;
        if (newsBox.isNotEmpty) {
          news = (newsBox.values.toList()[0] as List).map((el) => News.fromJson(Map<String, dynamic>.from(el))).toList();
        }
      });
    }
  }

  Future<void> checkInternetConnection() async {
    late List<ConnectivityResult> result;
    result = await Connectivity().checkConnectivity();

    setState(() {
      hasInternet = result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi);
    });
  }

  void onFilter({String? category, DateTime? date}) {
    fetchNews(
      category: category == "All" ? null : category,
      date: date,
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      onFilter(date: selectedDate, category: selectedCategory);
    }
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Сортировка по дате:",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      setState(() {
                        isSorted ? news.sort((a, b) => a.date.compareTo(b.date)) :
                          news.sort((a, b) => b.date.compareTo(a.date));
                          isSorted = !isSorted;
                      })
                    },  
                    child: Text(isSorted ? "По возрастанию" : "По убыванию", 
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black
                      ),
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Фильтры: ", 
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(selectedDate == null
                        ? "Выберите дату"
                        : "${selectedDate!.toLocal()}".split(' ')[0],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                        ),
                      ),
                  ),
                  DropdownButton(
                    value: selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, 
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                      onFilter(category: value, date: selectedDate);
                    },
                  ),
                ],
              ),
            ),
            isLoad ? CircularProgressIndicator() :
            Expanded(
              child: ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final currentNews = news[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 7, right: 10, left: 10, bottom: 5),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)
                      ),
                      onPressed: () => {
                        showBottomSheet(
                          context: context, 
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 500,
                              width: double.infinity,
                              child: SingleChildScrollView (
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6, right: 10),
                                          child: TextButton(
                                            child: const Text('Close',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    !hasInternet || currentNews.img == '' ? 
                                      Center(child: Text("Изображение отсутствует", style: TextStyle(fontSize: 20),)) 
                                    : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        width: 450,
                                        height: 250,
                                        currentNews.img,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, right: 8, left: 8),
                                      child: Text(currentNews.title,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5, right: 8, left: 8, bottom: 8),
                                      child: Text(currentNews.description,
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black87
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        )
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 3),
                          color: Colors.grey[400]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentNews.title, 
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black
                                ),
                              ),
                              Text(currentNews.date.toString().substring(0, currentNews.date.toString().length - 8),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  );
                }
              )
            )
          ]
        ),
      ),
    );
  }
}
