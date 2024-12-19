import 'package:flutter/material.dart';
import 'package:Todo/pages/add.dart';
import 'package:Todo/pages/edit.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {

  await Hive.initFlutter();
  await Hive.openBox('ToDoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: ThemeData(),
      home: MainPage(),
      routes: { 
        '/main': (context) => MainPage(),
        '/add' : (context) => AddPage(),
        '/edit' : (context) => EditPage(),
      }
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final List<String> filters = ["all", "Done", "Not Done"];
  String? selectedFilter;
  List filteredTasks = []; 

  final toDoBox = Hive.box('ToDoBox'); 

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
    filteredTasks = toDoBox.values.toList();
  }

  void getTasks() {
    if(selectedFilter == "Done") {
      filteredTasks = toDoBox.values.where((value) {
        return value['isDone'] == true;
      }).toList();
    }
    else if(selectedFilter == "Not Done") {
      filteredTasks = toDoBox.values.where((value) {
        return value['isDone'] == false;
      }).toList();
    }
    else {
      filteredTasks = toDoBox.values.toList();
    }
  }

  Future<void> _navigateAndRefresh(route, index) async {
    final result;
    if (route == '/edit') {
      result = await Navigator.pushNamed(context, route, arguments: index);
    }
    else {
      result = await Navigator.pushNamed(context, route);
    }

    if (result == true) {
      setState(() {
        getTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
         children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              children:
                filters.map((filter) {
                  return ChoiceChip(
                    label: Text(filter, 
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    selected: selectedFilter == filter,
                    selectedColor: Colors.green[400],
                    onSelected: (isSelected) {
                      setState(() {
                        selectedFilter = isSelected ? filter : filters[0];
                      });
                      getTasks();
                    }
                  );
                }).toList(),
              ),
            ),
            filteredTasks.isEmpty ? Center(child: Text('Нет запланированных задач', style: TextStyle(fontSize: 22, color: Colors.black),),) : 
            Column(
              children: 
                List<Widget>.generate(filteredTasks.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(filteredTasks[index]['title'],
                              style: TextStyle(
                                fontSize: 24
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                            child: Text(filteredTasks[index]['description'], 
                              style: TextStyle(
                                fontSize: 18
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green
                                  ),
                                  onPressed: () => {
                                    setState(() {
                                      filteredTasks[index]["isDone"] = true;
                                      getTasks();
                                    })
                                  } ,
                                  child: Text("Done",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    ),
                                  )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red
                                  ),
                                  onPressed: () => {
                                    setState(() {
                                      toDoBox.deleteAt(index);
                                      getTasks();
                                    })
                                  },
                                  child: Text("Delete", 
                                    style: TextStyle(
                                      fontSize: 20, 
                                      color: Colors.white
                                    ),
                                  )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey
                                  ),
                                  onPressed: () => {
                                    _navigateAndRefresh('/edit', index)
                                  },
                                  child: Text("Edit", 
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                    ),
                                  )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                })
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _navigateAndRefresh('/add', "")
          // toDoBox.clear()
          // print(filteredTasks)
        },
        child: const Icon(Icons.add, 
          size: 34,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
