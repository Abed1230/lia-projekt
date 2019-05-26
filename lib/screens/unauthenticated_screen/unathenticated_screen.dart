import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class UnauthenticatedScreen extends StatefulWidget {
  UnauthenticatedScreen(this.onSignedIn);

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _UnauthenticatedScreenState();
}

class _UnauthenticatedScreenState extends State<UnauthenticatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(MyStrings.appName)),
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}