import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {

  double input = 0;
  String selectedValue = "sec";
  List<String> values = ["sec", "min", "hour"];

  String converter(String type, double value) {
    if (selectedValue == type) {
      return value.toString();
    }
    else if (selectedValue == "sec") {
      if (type == "min") {
        value /= 60;
      }
      else {
        value /= 3600;
      }
    }
    else if (selectedValue == "min") {
      if (type == "hour") {
        value /= 60;
      }
      else {
        value *= 60;
      }
    }
    else if (selectedValue == "hour") {
      if (type == "sec") {
        value *= 3600;
      }
      else {
        value *= 60;
      }
    }
    return value.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Time"
        ),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Ввод',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.deepPurple
                        )
                      )
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))
                    ],
                    onChanged: (value) => {
                      setState(() {
                        if (value == "") {
                          input = 0;
                        }
                        else {
                          input = double.parse(value);
                        }
                      })
                      },
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 90,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        value: selectedValue,
                        items: values.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 20
                              ),
                            )
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            selectedValue = newVal!;
                          });
                        }
                      ),
                    )
                  ),
                )
              ],
            ),
            Container(
              width: 360,
              decoration: BoxDecoration(
                border: Border(bottom: 
                  BorderSide(
                    width: 2, 
                    color: Colors.black
                  )
                )
              ),
              child: Text("Результаты конвертации",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(
                    color: Colors.black,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "sec: " + converter("sec", input),
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(
                    color: Colors.black,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "min: " + converter("min", input),
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: 300,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  border: Border.all(
                    color: Colors.black,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "hour: " + converter("hour", input),
                        style: TextStyle(fontSize: 24),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}