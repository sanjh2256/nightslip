import 'package:flutter/material.dart';
class EndCalendarPage extends StatefulWidget {
  final DateTime startDate;
  final String startTime;

  const EndCalendarPage({
    Key? key,
    required this.startDate,
    required this.startTime,
  }) : super(key: key);

  @override
  _EndCalendarPageState createState() => _EndCalendarPageState();
}

class _EndCalendarPageState extends State<EndCalendarPage> {
  late DateTime currentMonth;
  late int selectedDate;
  late DateTime today;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    // Initialize with the same month as startDate or current month if startDate is in the past
    currentMonth = widget.startDate.isAfter(today)
        ? DateTime(widget.startDate.year, widget.startDate.month)
        : DateTime(today.year, today.month);
    // Default selected date to the day after startDate
    selectedDate = widget.startDate.day + 1;
    // Make sure selectedDate is valid for the current month
    if (selectedDate > _getDaysInMonth(currentMonth.year, currentMonth.month)) {
      // If adding a day overflows the month, move to next month
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDate = 1;
    }
  }

  // Generate time options every 15 minutes from 8:30 PM to 1:00 PM
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

    // Morning/Afternoon times (12:00 AM to 1:00 PM)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 50, // Reduce the overall height
        leadingWidth: 30, // Reduce leading width
        leading: Icon(Icons.menu, color: Colors.white, size: 20), // Smaller icon
        titleSpacing: 0, // Reduce spacing before title
        title: Row(
          mainAxisSize: MainAxisSize.min, // Make row take minimum space
          children: [
            Image.asset(
              'assets/logosmall.png',
              height: 16, // Smaller logo
            ),
            SizedBox(width: 4), // Smaller gap
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 6), // Smaller margin
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.orange,
                side: BorderSide(color: Colors.orange, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Smaller radius
                ),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Smaller padding
                minimumSize: Size(0, 30), // Reduce minimum height
                tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove extra padding
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 10, // Keep icon small
                  ),
                  SizedBox(width: 4), // Smaller gap
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12, // Smaller font
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
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            margin: const EdgeInsets.only(bottom: 6.0),
            width: double.infinity,
            child: Container(
              child: Text(
                'Calendar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange[800],
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                ),
              ),
            ),
          ),
          // End date selection container with gradient
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
                'Choose your End Date Below',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          // Month navigation
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: 36),
                  onPressed: () {
                    // Don't allow navigating to months before start date month
                    DateTime newMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                    if (newMonth.year >= widget.startDate.year &&
                        newMonth.month >= widget.startDate.month) {
                      setState(() {
                        currentMonth = newMonth;
                        // Adjust selectedDate if needed when changing months
                        if (selectedDate > _getDaysInMonth(currentMonth.year, currentMonth.month)) {
                          selectedDate = _getDaysInMonth(currentMonth.year, currentMonth.month);
                        }
                      });
                    }
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
                  icon: Icon(Icons.chevron_right, color: Colors.white, size: 36),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
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
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Choose To Time:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'DMSerifText',
                    fontSize: 18,
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
                        hint: Text(
                          'Select Time',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'DMSerifText',
                            fontSize: 18,
                          ),
                        ),
                        isExpanded: true,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'DMSerifText',
                          fontSize: 18,
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
                  // Create end date time
                  final endDate = DateTime(currentMonth.year, currentMonth.month, selectedDate);

                  // Check if end date is after start date
                  if (endDate.isAfter(widget.startDate)) {
                    // Navigate to confirmation or booking page with both start and end times
                    // You can implement this as needed
                    Navigator.pop(context, {
                      'startDate': widget.startDate,
                      'startTime': widget.startTime,
                      'endDate': endDate,
                      'endTime': selectedTime,
                    });
                  } else {
                    // Show error if end date is before or same as start date
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('End date must be after start date'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  // Show error if time not selected
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
                'SUBMIT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DMSerifText',
                  fontSize: 20,
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

    // Start date for dimming past dates
    final startDateTime = widget.startDate;

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
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DMSerifText',
                      fontSize: 20,
                    ),
                  ),
                )
            ).toList(),
          ),
          // Line below day headers
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            color: Colors.orange.shade800,
          ),
          SizedBox(height: 6),
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
                return Container(); // Empty cell before the first day
              }

              final day = index - dayOfWeek + 1;
              final isSelected = day == selectedDate &&
                  currentMonth.year == currentMonth.year &&
                  currentMonth.month == currentMonth.month;

              // Check if this date is before or equal to the start date
              final currentDate = DateTime(currentMonth.year, currentMonth.month, day);
              final isBeforeStartDate = currentDate.isBefore(startDateTime) ||
                  (currentDate.year == startDateTime.year &&
                      currentDate.month == startDateTime.month &&
                      currentDate.day == startDateTime.day);

              return GestureDetector(
                onTap: () {
                  // Only allow selection of dates after start date
                  if (!isBeforeStartDate) {
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
                      color: isBeforeStartDate ? Colors.grey[600] : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'DMSerifText',
                      fontSize: 18,
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
}