import 'package:flutter/material.dart';
import 'LandingPage.dart';
import 'DetailsPage.dart';
import 'ImportPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Night slip ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: ImportPage(),
    );
  }
}