import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String heading = "";
  String description = "";

  final _focusNode = FocusNode();
  final toDoBox = Hive.box('ToDoBox');

  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) => {
                    setState(() {
                        heading = value;
                    })
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: TextField(
                  focusNode: _focusNode,
                  minLines: 5,
                  maxLines: 10,
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
                  onChanged: (value) => {
                    description = value,
                  },  
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
                    if(heading != ""){
                      toDoBox.add({'title': heading, 'description': description, 'isDone': false}),
                      Navigator.pop(context, true)
                    }
                  },
                  child: Text("Create", 
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