import 'package:flutter/material.dart';

class EndCalendarPage extends StatefulWidget {
  const EndCalendarPage({Key? key}) : super(key: key);

  @override
  _EndCalendarPageState createState() => _EndCalendarPageState();
}

class _EndCalendarPageState extends State<EndCalendarPage> {
  int selectedDate = 28; // Default to highlighted date
  DateTime currentMonth = DateTime(2025, 2); // February 2025
  String? selectedTime;

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

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: 30, // Adjust based on month
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          int day = index + 1;
          bool isSelected = selectedDate == day;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = day;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange[800] : Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$day',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
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
            Image.asset('assets/logosmall.png', height: 24),
            SizedBox(width: 8),
            Text(
              'THE COMPUTER SOCIETY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                'Choose your End Date Below',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  'Choose To Time:',
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
                        value: selectedTime,
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
                // Handle submission
                if (selectedTime != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selected Date: $selectedDate, Time: $selectedTime'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a time!'),
                      duration: Duration(seconds: 2),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
