import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  double input = 0;
  String selectedValue = "₽";
  List<String> values = ["₽", "\$", "€"];

  String converter(String type, double value) {
    if (selectedValue == type) {
      return value.toString();
    }
    else if (selectedValue == "₽") {
      if (type == "\$") {
        value /= 108;
      }
      else {
        value /= 113.98;
      }
    }
    else if (selectedValue == "\$") {
      if (type == "€") {
        value *= 0.947;
      }
      else {
        value *= 108;
      }
    }
    else if (selectedValue == "€") {
      if (type == "₽") {
        value *= 113.98;
      }
      else {
        value *= 1.0552;
      }
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency"
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
                        "₽: " + converter("₽", input),
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
                        "\$: " + converter("\$", input),
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
                        "€: " + converter("€", input),
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