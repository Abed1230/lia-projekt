import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/root_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: MyStrings.appName,
      home: new RootScreen(),
    );
  }
}
