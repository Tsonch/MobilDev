import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  List? tasks;
  final _heading = TextEditingController();
  final _description = TextEditingController();

  final _focusNode = FocusNode();
  final toDoBox = Hive.box('ToDoBox');

  @override
  void initState() {
    super.initState();
    tasks = toDoBox.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    int ind = ModalRoute.of(context)!.settings.arguments as int;
    _heading.text = tasks![ind]['title'];
    _description.text = tasks![ind]['description'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
        backgroundColor: Colors.green,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
            _focusNode.unfocus();
        },
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: TextField(
                  controller: _heading,
                  style: TextStyle(
                    fontSize: 22
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Заголовок",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3
                      ),  
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    )  
                  ),
                  // onChanged: (value) => {
                  //   setState(() {
                  //       heading = value;
                  //   })
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: TextField(
                  focusNode: _focusNode,
                  minLines: 5,
                  maxLines: 10,
                  controller: _description,
                  style: TextStyle(
                    fontSize: 22
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Описание",
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3
                      ),  
                      borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    )  
                  ),
                  // onChanged: (value) => {
                  //   discription = value,
                  // },  
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50)
                  ),
                  onPressed: () => {
                    if(_heading.text != ""){
                      toDoBox.putAt(ind, {'title': _heading.text, 'description': _description.text, 'isDone': tasks![ind]['isDone']}),
                      Navigator.pop(context, true)
                    }
                  },
                  child: Text("Save", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24
                    ),
                  )
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}