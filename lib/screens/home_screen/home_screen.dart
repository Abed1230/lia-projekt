import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class HomeScreen extends StatefulWidget {
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
        child: RaisedButton(
          child: Text('go'),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => new OtherScreen()));
          },
        ),
      ),
    );
  }
}

class OtherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Other'),
    );
  }
}
