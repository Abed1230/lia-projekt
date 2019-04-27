import 'package:flutter/material.dart';
import 'package:karlekstanken/screens/home_screen.dart';
import 'package:karlekstanken/my_strings.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: MyStrings.appName,
      home: new HomeScreen(),
    );
  }
}
