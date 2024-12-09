import 'dart:math';

import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      home: const Calculator(title: 'Calculator'),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key, required this.title});

  final String title;

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String userInput = '';

  List<String> calcArr = ['C', 'del', '^', '/','7', '8', '9', '*', '4', '5', '6', '-', '1', '2', '3',  '+', 'sqrt', '0', '.', '='];
  List<String> operators = ['+', '-', '*', '/', '^'];

  bool isNum (String el) {
    try {
      int.parse(el);
      return true;
    }
    catch (exeption) {
      return false;
    }
  }

  void operation (String input) {
    setState(() {
      if (userInput == "Error") {
        userInput == '';
      }
      int length = userInput.length;
      if (input == "=") {
        calc();
      }
      else if (input == "sqrt") {
        if (length > 0) {
          calc();
          if (userInput[0] != "-") {
            double res = sqrt(double.parse(userInput));
            userInput = res.toStringAsFixed(3);
          }
          else {
            userInput == "Error";
          }
        }
      }
      else if (input == "C") {
        userInput = '';
      }
      else if (input == "del") {
        if (userInput == "Error") {
          userInput = '';
          return;
        }
        if (length > 0) {
          RegExp regex = RegExp("\\-[1-9]+");
          RegExp regex1 = RegExp("[1-9]+\\-[1-9]+");
          if (regex.hasMatch(userInput) && !regex1.hasMatch(userInput)) {
            userInput = '';
            return;
          }
          userInput = userInput.substring(0, userInput.length - 1);
        }
      }
      
      else if (operators.contains(input) && userInput == '' || (userInput == '' && input == ".")) {
        return;
      }
      else if ((input == "." || operators.contains(input)) && userInput[length - 1] == ".") {
        return;
      }
      else if (length > 0 && (userInput[length - 1] == "0") && (length == 1 || operators.contains(userInput[length - 2]))) {
        if (input == ".") {
          userInput += input;
        }
        else if (userInput == "0") {
          userInput += input;
        }
        else if (operators.contains(userInput[length - 2])) {
          return;
        }
        else {
          userInput = userInput.substring(0, length - 1);
          userInput += input;
        }
      }
      else if (input == ".") {
        if (operators.contains(userInput[length - 1])) {
          return;
        }
        else {
          for (int i = length - 1; i >= 0; i--) {
            if (operators.contains(userInput[i])) {
              break;
            }
            else if (userInput[i] == ".") {
              return;
            }
          }
        }
        userInput += input;
      }
      else if (operators.contains(input) && operators.contains(userInput[length - 1])) {
        userInput = userInput.substring(0, length - 1);
        userInput += input;
      }
      else {
        userInput += input;
      }
    });
  }

  void calc () {
    RegExp regex = RegExp("/0");
    RegExp regex1 = RegExp("0.[0-9]*[1-9]");
    if (regex.hasMatch(userInput) && !regex1.hasMatch(userInput)) {
      userInput = "Error";
      return;
    }
    if (operators.contains(userInput[userInput.length - 1])) {
      userInput = userInput.substring(0, userInput.length - 1);
    }
    Expression exp  = Parser().parse(userInput);
    double result = exp.evaluate(EvaluationType.REAL, ContextModel());
    userInput = result.toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black54,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  child: Text(
                  userInput, 
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.right
                ),
                )
              ),
            ),
            Expanded(
              child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemCount: calcArr.length,
              itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3),
                    child: ElevatedButton(onPressed: () {
                      operation(calcArr[index]);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: isNum(calcArr[index]) || calcArr[index]=='.'? Colors.white24 : const Color.fromARGB(255, 228, 61, 0),
                        foregroundColor: Colors.white,
                      ), 
                    child: Text(calcArr[index], 
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 24
                      ),
                    )
                    ),
                  );
                }
              )
            )
          ],
        ),
      ),
    );
  }
}