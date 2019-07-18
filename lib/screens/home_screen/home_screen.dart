import 'package:flutter/material.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this._userId);

  final String _userId;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print(context.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.homeScreenTitle),
      ),
      body: Center(
          child: RaisedButton(
        child: Text('Parning'),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StreamProvider<User>.value(
                      value: Provider.of<DatabaseService>(context).streamUser(widget._userId), child: PairingScreen(widget._userId))));
        },
      )),
    );
  }
}
