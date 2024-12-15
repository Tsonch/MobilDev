import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'main',
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();

  final weekDays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  bool isSameMonthAndYear(DateTime current, DateTime selected) {
    return current.month == selected.month && current.year == selected.year;
  }

  bool isSameDate(DateTime current, DateTime selected) {
    return currentDate.year == selected.year && currentDate.month == selected.month && current.day == selected.day;
  }

  void monthChange(int value) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + value);
    });
  }

 Widget getMonthDay() {
  List<DateTime> days = [];
  int needPrevMonthDays = DateTime(selectedDate.year, selectedDate.month, 1).weekday - 1;
  int prevMonth = selectedDate.month == 1 ? 12 : selectedDate.month - 1;
  int nextMonth = selectedDate.month == 12 ? 1 : selectedDate.month + 1;
  int prevYear = selectedDate.month == 1 ? selectedDate.year - 1 : selectedDate.year;
  int nextYear = selectedDate.month == 12 ? selectedDate.year + 1 : selectedDate.year;

  int currentMonthDays = DateUtils.getDaysInMonth(selectedDate.year, selectedDate.month);
  int prevMonthDays = DateUtils.getDaysInMonth(selectedDate.year, prevMonth);

  int needNextMonthDays = 7 - DateTime(selectedDate.year, selectedDate.month, currentMonthDays).weekday;

  for(int i = needPrevMonthDays, j = prevMonthDays; i > 0 ; i--, j--) {
    days.insert(0, DateTime(prevYear, prevMonth, j));
  }
  for(int i = 1; i <= currentMonthDays; i++) {
    days.add(DateTime(selectedDate.year, selectedDate.month, i));
  }
  for(int i = 1; i <= needNextMonthDays; i++) {
    days.add(DateTime(nextYear, nextMonth, i));
  }
  return Padding(
    padding: const EdgeInsets.only(left: 5, right: 5),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
      itemCount: days.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Center(
              child: Text(days[index].day.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: isSameMonthAndYear(currentDate, days[index]) ? Colors.black : Colors.grey,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: isSameDate(currentDate, days[index]) ? Colors.deepPurple : Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    ),
  );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text("Calendar", 
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          if (!isSameMonthAndYear(currentDate, selectedDate))
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => {
                setState(() {
                  selectedDate = currentDate;
                })
              },
              color: Colors.black,
            ),
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back, 
                        color: Colors.white,
                      ),
                      onPressed: () => monthChange(-1),   
                    ),
                    Text(
                      DateFormat.yMMMM().format(selectedDate),
                      style: TextStyle(
                        fontSize: 20,
                        color: isSameMonthAndYear(currentDate, selectedDate)? Colors.white : Colors.white60,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      onPressed: () => monthChange(1),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 7,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(7, (index) {
                return Center(
                  child: Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                );
              }),
            ),
            getMonthDay(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 200,
                height: 55,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: DropdownButton<int>(
                  dropdownColor: Colors.deepPurple,
                  menuMaxHeight: 100,
                  value: selectedDate.year,
                  items: List.generate(
                    50,
                    (index) => DropdownMenuItem(
                      alignment: AlignmentDirectional.center,
                      value: 1994 + index,
                      child: Text(
                        (1994 + index).toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                      )
                    )
                  ),
                  onChanged: (year) => {
                    setState(() {
                      selectedDate = DateTime(year!, selectedDate.month, selectedDate.day);
                    })
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}