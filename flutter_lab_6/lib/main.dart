import 'package:flutter/material.dart';
import 'package:FoodApp/pages/favorite.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('FoodBox');

  await Supabase.initialize(
    url: 'https://retpyhbpuzbtbfndvpox.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJldHB5aGJwdXpidGJmbmR2cG94Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ0MzQxMjAsImV4cCI6MjA1MDAxMDEyMH0.M3_gsoyavKlrEu1K1LT8kOq6wJGlH8OyXNBWsXgonP0'
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DishesApp',
      theme: ThemeData(),
      home: MainPage(),
      routes: {
        '/home': (context) => MainPage(),
        '/favorite': (context) => FavoritePage()
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

  var supabase = Supabase.instance.client;
  List<Map<String, dynamic>> dishes = [];
  List<Map<String, dynamic>> filteredDishes = [];

  final favoriteBox = Hive.box('FoodBox');

  Future<void> _navigateAndRefresh() async {
    final result = await Navigator.pushNamed(context, '/favorite');

    if (result == true) {
      setState(() {
        loadDishes();
      });
    }
  }

  void filterDishes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDishes = List.from(dishes);
      } else {
        filteredDishes = dishes.where((dish) =>
            dish['name']!.toLowerCase().contains(query.toLowerCase()) ||
            dish['category']!.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }
    });
  }

  Future<void> loadDishes() async {
    final response = await supabase.from('Dishes').select();

    if (response == []) {
      throw Exception(response);
    }

    setState(() {
      dishes = response;
      filteredDishes = dishes;
    });
  }

  Future<void> updateStatus(int id, bool newStatus) async {
    await Supabase.instance.client.from('Dishes').update({'isFavorite' : newStatus}).eq('id', id);
  }  

  Future<void> deleteDishById(int id) async {
    final keyToDelete = favoriteBox.keys.firstWhere(
      (key) {
        final dish = favoriteBox.get(key);
        return dish['id'] == id;
      },
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await favoriteBox.delete(keyToDelete);
    } else {
      print('Блюдо "$id" не найдено.');
    }
  }

  @override
  void initState() {
    super.initState();
    loadDishes();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text("DishesApp"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              color: Colors.white,
              iconSize: 30,
              onPressed: () => {
                _navigateAndRefresh()
              },
              icon: Icon(Icons.favorite)
            ),
          )
        ],
      ),
      body: 
        Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 20),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.black,
                ),
                onChanged: filterDishes
              ),
            ),
            Expanded(
              child: filteredDishes.isEmpty ? Center(child: Text('Нет результатов', style: TextStyle(fontSize: 22, color: Colors.white),)) :
              ListView.builder(
                itemCount: filteredDishes.length,
                itemBuilder: (context, index) {
                  final dish = filteredDishes[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 7, right: 10, left: 10, bottom: 3),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)
                      ),
                      onPressed: () => {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Название: ' + dish['name'], style: TextStyle(fontSize: 22),),
                                    Text('Категория: ' + dish['category'], style: TextStyle(fontSize: 20),),
                                    Text('Порция: ' + dish['gramms'].toString(), style: TextStyle(fontSize: 20),),
                                    Text('Калории: ' + dish['calories'].toString(), style: TextStyle(fontSize: 20),),
                                    Text('Белки:' + dish['proteins'].toString(), style: TextStyle(fontSize: 20),),
                                    Text('Жиры: ' + dish['fats'].toString(), style: TextStyle(fontSize: 20),),
                                    Text('Углеводы: ' + dish['carbohydrates'].toString(), style: TextStyle(fontSize: 20),),
                                    Text('Противопоказания: ' + dish['contraindications'], style: TextStyle(fontSize: 20),),
                                    Text('Состав: ' + dish['ingredients'], style: TextStyle(fontSize: 20),)
                                  ],
                                ),
                              ),
                            );
                          }
                        )
                      },
                      child: Container(
                        width: double.infinity,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black87,
                            width: 3
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(dish['name'], 
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                IconButton(
                                  iconSize: 25,
                                  onPressed: () => {
                                    if (dish['isFavorite'] == true) {
                                      updateStatus(dish['id'], false),
                                      deleteDishById(dish['id']),
                                      setState(() {
                                        dish['isFavorite'] = false;
                                      })
                                    }
                                    else {
                                      updateStatus(dish['id'], true),
                                      favoriteBox.add(dish),
                                      setState(() {
                                        dish['isFavorite'] = true;
                                      })
                                    },
                                    print(favoriteBox.values.toList())
                                    // favoriteBox.clear()
                                  },
                                  icon: dish['isFavorite'] ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border)
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, right: 6, left: 6),
                              child: Text("Состав: " + dish['ingredients'], 
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              )
            )
          ]
        )
      )
    );
  }
}
