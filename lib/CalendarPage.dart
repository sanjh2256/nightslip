import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'EndCalendarPage.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime currentMonth;
  late int selectedDate;
  late DateTime today;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    currentMonth = DateTime(today.year, today.month);
    selectedDate = today.day;
  }

  // Generate time options every 15 minutes from 8:30 PM to 1:00 AM
  List<String> generateTimeOptions() {
    List<String> options = [];

    // Evening times (8:30 PM to 11:45 PM)
    for (int hour = 20; hour <= 23; hour++) {
      for (int minute = (hour == 20 ? 30 : 0); minute < 60; minute += 15) {
        final hourStr = hour == 12 ? 12 : hour % 12;
        final minuteStr = minute.toString().padLeft(2, '0');
        options.add('$hourStr:$minuteStr PM');
      }
    }

    // Early morning times (12:00 AM to 1:00 AM)
    for (int hour = 0; hour <= 1; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        if (hour == 1 && minute > 0) break; // Stop at 1:00 AM
        final hourStr = hour == 0 ? 12 : hour;
        final minuteStr = minute.toString().padLeft(2, '0');
        options.add('$hourStr:$minuteStr AM');
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
        toolbarHeight: 40,
        leadingWidth: 20,
        leading: Icon(Icons.menu, color: Colors.white, size: 20),
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/logosmall.png',
              height: 20,
            ),
            SizedBox(width: 4), // Smaller gap
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.orange,
                side: BorderSide(color: Colors.orange, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                minimumSize: Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 10,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar title with lines above and below
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.orange.shade800, width: 2.0),
                bottom: BorderSide(color: Colors.orange.shade800, width: 2.0),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            margin: const EdgeInsets.only(bottom: 4.0),
            width: double.infinity,
            child: Container(
              child: Text(
                'Calendar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                ),
              ),
            ),
          ),
          // Start date selection container with gradient
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade800, Colors.deepOrange.shade900],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Center(
              child: Text(
                'Choose your Start Date Below',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 30),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month - 1,
                      );
                      // Adjust selectedDate if needed when changing months
                      if (selectedDate > _getDaysInMonth(currentMonth.year, currentMonth.month)) {
                        selectedDate = _getDaysInMonth(currentMonth.year, currentMonth.month);
                      }
                    });
                  },
                ),
                Text(
                  '${_getMonthName(currentMonth.month)}, ${currentMonth.year}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DMSerifText',
                    fontSize: 24,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, color: Colors.white, size: 30),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                        currentMonth.year,
                        currentMonth.month + 1,
                      );
                      // Adjust selectedDate if needed when changing months
                      if (selectedDate > _getDaysInMonth(currentMonth.year, currentMonth.month)) {
                        selectedDate = _getDaysInMonth(currentMonth.year, currentMonth.month);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          _buildCalendar(),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  'Choose From Time:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DMSerifText',
                    fontSize: 16,
                  ),
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
                        value: selectedTime,
                        hint: Text('Select Time',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'DMSerifText',
                            fontSize: 16,
                          ),
                        ),
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSerifText',
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedTime = value;
                          });
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
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedTime != null) {
                  // Navigate to the next page (EndCalendarPage) with the selected date and time
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EndCalendarPage(
                        startDate: DateTime(currentMonth.year, currentMonth.month, selectedDate),
                        startTime: selectedTime!,
                      ),
                    ),
                  );
                } else {
                  // Show an error message if time is not selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a time'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'NEXT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                  fontSize: 20, // Increased font size
                ),
              ),
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

    // Calculate yesterday's date for dimming past dates
    final yesterday = DateTime.now().subtract(Duration(days: 1));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.black.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) =>
                Container(
                  width: 40, // Wider containers
                  height: 40, // Taller containers
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSerifText',
                      fontSize: 24, // Increased font size
                    ),
                  ),
                )
            ).toList(),
          ),
          // Line below day headers
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.orange.shade800,
          ),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
            ),
            itemCount: dayOfWeek + daysInMonth,
            itemBuilder: (context, index) {
              if (index < dayOfWeek) {
                return Container();
              }

              final day = index - dayOfWeek + 1;
              final isSelected = day == selectedDate &&
                  currentMonth.year == today.year &&
                  currentMonth.month == today.month;

              // Check if this date is in the past
              final currentDate = DateTime(currentMonth.year, currentMonth.month, day);
              final isPastDate = currentDate.isBefore(yesterday);

              return GestureDetector(
                onTap: () {
                  // Only allow selection of current or future dates
                  if (!isPastDate) {
                    setState(() {
                      selectedDate = day;
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.orange[800] : Colors.transparent,
                    gradient: isSelected ? LinearGradient(
                      colors: [Colors.orange.shade700, Colors.deepOrange.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isPastDate ? Colors.grey[600] : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'DMSerifText',
                      fontSize: 18, // Increased font size
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