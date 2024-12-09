import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthPage extends StatefulWidget {
  const LengthPage({super.key});

  @override
  State<LengthPage> createState() => _LengthPageState();
}

class _LengthPageState extends State<LengthPage> {

  double input = 0;
  String selectedValue = "cm";
  List<String> values = ["mm", "cm", "m"];

  String converter(String type, double value) {
    String val = "";

    if (selectedValue == type) {
      return value.toString();
    }
    else if (selectedValue == "mm") {
      if (type == "cm") {
        val = (value / 10).toStringAsFixed(1);
      }
      else {
        val = (value / 1000).toStringAsFixed(3);
      }
    }
    else if (selectedValue == "cm") {
      if (type == "m") {
        val = (value / 100).toStringAsFixed(2);
      }
      else {
        val = (value * 10).toStringAsFixed(2);
      }
    }
    else if (selectedValue == "m") {
      if (type == "mm") {
        val = (value * 1000).toStringAsFixed(2);
      }
      else {
        val = (value * 100).toStringAsFixed(2);
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Length"
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
                    width: 80,
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
                        "mm: " + converter("mm", input),
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
                        "cm: " + converter("cm", input),
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
                        "m: " + converter("m", input),
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