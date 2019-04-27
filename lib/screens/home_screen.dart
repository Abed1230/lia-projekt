import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(MyStrings.homeScreenTitle),
      ),
    );
  }
}
