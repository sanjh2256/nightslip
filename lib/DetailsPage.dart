import 'package:flutter/material.dart';
import 'CalendarPage.dart';
import 'ProfilePage.dart';

class User {
  String fullName;
  String phoneNumber;
  String email;
  String hostelType;
  String hostelBlock;
  String roomNumber;

  User({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.hostelType,
    required this.hostelBlock,
    required this.roomNumber,
  });

  // Mock user for demonstration
  static User mockUser() {
    return User(
      fullName: 'Nethra Krishnan',
      phoneNumber: '+91 XXXXX 00000',
      email: 'xyz@gmail.com',
      hostelType: 'Ladies Hostel',
      hostelBlock: 'LH-D',
      roomNumber: '500',
    );
  }
}

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String? selectedHostType;
  final blockNameController = TextEditingController();
  final roomNumberController = TextEditingController();
  final nameController = TextEditingController(text: 'Nethra');

  final List<String> hostTypes = ['Ladies Hostel', 'Mens Hostel'];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/logosmall.png', // Logo image
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF9800),
                ),
                child: Center(
                  child: Text(
                    'CS',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        title: Text(
          'THE COMPUTER SOCIETY',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        actions: [
          InkWell(
            onTap: () {
              // Placeholder for profile navigation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile button clicked')),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFFF9800)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Profile', style: TextStyle(color: Color(0xFFFF9800))),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome, Nethra',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Enter your Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text('Hostel Type', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF9800)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: selectedHostType,
                    hint: Text('Select Hostel Type', style: TextStyle(color: Colors.grey)),
                    dropdownColor: Colors.black,
                    iconEnabledColor: Color(0xFFFF9800),
                    style: TextStyle(color: Colors.white),
                    items: hostTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(type),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHostType = newValue;
                      });
                    },
                    isExpanded: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select hostel type';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Block Name', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF9800)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextFormField(
                  controller: blockNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter block name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Text('Room Number', style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFFF9800)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextFormField(
                  controller: roomNumberController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    errorStyle: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // All fields are valid, proceed to calendar
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('SUBMIT', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
