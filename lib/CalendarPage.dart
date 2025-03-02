import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selectedDate = 25; // Default to highlighted date from image 1
  DateTime currentMonth = DateTime(2025, 2); // February 2025
  TimeOfDay? selectedTime;

  // Generate time options every 15 minutes from 8:30 PM to 1:00 PM
  List<String> generateTimeOptions() {
    List<String> options = [];

    // Evening times (PM)
    for (int hour = 20; hour <= 23; hour++) {
      for (int minute = (hour == 20 ? 30 : 0); minute < 60; minute += 15) {
        final hourStr = hour == 12 ? 12 : hour % 12;
        final minuteStr = minute.toString().padLeft(2, '0');
        options.add('$hourStr:$minuteStr PM');
      }
    }

    // Morning/Afternoon times (AM/PM)
    for (int hour = 0; hour <= 13; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        if (hour == 13 && minute > 0) break; // Stop at 1:00 PM
        final period = hour >= 12 ? 'PM' : 'AM';
        final hourStr = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
        final minuteStr = minute.toString().padLeft(2, '0');
        options.add('$hourStr:$minuteStr $period');
      }
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.menu, color: Colors.white),
        title: Row(
          children: [
            Image.asset(
              'assets/logosmall.png',
              height: 24,
            ),
            SizedBox(width: 8),

          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Profile', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Calendar',
              style: TextStyle(
                color: Colors.orange[800],
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 8),
            color: Colors.orange[800],
            child: Center(
              child: Text(
                'Choose your Start Date Below',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  '${_getMonthName(currentMonth.month)}, ${currentMonth.year}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month + 1,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          _buildCalendar(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Choose From Time:',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white,
                        hint: Text('Select Time', style: TextStyle(color: Colors.white70)),
                        isExpanded: true,
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          // Handle time selection
                        },
                        items: generateTimeOptions().map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    final daysInMonth = _getDaysInMonth(currentMonth.year, currentMonth.month);
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final dayOfWeek = firstDayOfMonth.weekday % 7; // 0 is Sunday in our display

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) =>
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ).toList(),
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: dayOfWeek + daysInMonth,
            itemBuilder: (context, index) {
              if (index < dayOfWeek) {
                return Container(); // Empty cell before the first day
              }

              final day = index - dayOfWeek + 1;
              final isSelected = day == selectedDate;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = day;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.orange[800] : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
}