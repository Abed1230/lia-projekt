import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this._userId);

  final String _userId;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.homeScreenTitle),
      ),
      body: Center(
        child: Text(widget._userId),
      ),
    );
  }
}