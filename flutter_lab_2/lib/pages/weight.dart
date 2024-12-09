import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {

  double input = 0;
  String selectedValue = "g";
  List<String> values = ["g", "kg", "t"];

  String converter(String type, double value) {
    String val = "";
    if (selectedValue == type) {
      return value.toString();
    }
    else if (selectedValue == "g") {
      if (type == "kg") {
        val = (value / 1000).toStringAsFixed(3);
      }
      else {
        val = (value / 1000000).toStringAsFixed(6);
      }
    }
    else if (selectedValue == "kg") {
      if (type == "t") {
        val = (value / 1000).toStringAsFixed(3);
      }
      else {
        val = (value * 1000).toStringAsFixed(1);
      }
    }
    else if (selectedValue == "t") {
      if (type == "g") {
        val = (value * 1000000).toStringAsFixed(1);
      }
      else {
        val = (value * 1000).toStringAsFixed(1);
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weight"
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
                    width: 75,
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
                        "g: " + converter("g", input),
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
                        "kg: " + converter("kg", input),
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
                        "t: " + converter("t", input),
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