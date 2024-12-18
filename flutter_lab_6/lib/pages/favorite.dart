import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  List? favorites;

  final favoriteBox = Hive.box('FoodBox');

  @override
  void initState() {
    super.initState();
    favorites = favoriteBox.values.toList();
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
      print('Блюдо "$id" удалено.');
    } else {
      print('Блюдо "$id" не найдено.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text('Избранное'),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context, true)},
          icon: Icon(Icons.arrow_back)
        )
      ),
      body: 
        favorites!.isEmpty ? Center( child: Text('Нет избранных блюд', style: TextStyle(fontSize: 24, color: Colors.white),)) :
        Center(
          child: Column(
            children: List<Widget>.generate(favorites!.length, (index) {
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
                                Text('Название: ' + favorites![index]['name'], style: TextStyle(fontSize: 22),),
                                Text('Категория: ' + favorites![index]['category'], style: TextStyle(fontSize: 20),),
                                Text('Порция: ' + favorites![index]['gramms'].toString(), style: TextStyle(fontSize: 20),),
                                Text('Калории: ' + favorites![index]['calories'].toString(), style: TextStyle(fontSize: 20),),
                                Text('Белки:' + favorites![index]['proteins'].toString(), style: TextStyle(fontSize: 20),),
                                Text('Жиры: ' + favorites![index]['fats'].toString(), style: TextStyle(fontSize: 20),),
                                Text('Углеводы: ' + favorites![index]['carbohydrates'].toString(), style: TextStyle(fontSize: 20),),
                                Text('Противопоказания: ' + favorites![index]['contraindications'], style: TextStyle(fontSize: 20),),
                                Text('Состав: ' + favorites![index]['ingredients'], style: TextStyle(fontSize: 20),)
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
                              child: Text(favorites![index]['name'], 
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20
                                ),
                              ),
                            ),
                            IconButton(
                              iconSize: 25,
                              onPressed: () => {
                                if (favorites![index]['isFavorite'] == true) {
                                  updateStatus(favorites![index]['id'], false),
                                  deleteDishById(favorites![index]['id']),
                                  setState(() {
                                    favorites = favoriteBox.values.toList();
                                  })
                                }
                              },
                              icon: favorites![index]['isFavorite'] ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border)
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 6, left: 6),
                          child: Text("Состав: " + favorites![index]['ingredients'], 
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
        ),
      )
    );
  }
}