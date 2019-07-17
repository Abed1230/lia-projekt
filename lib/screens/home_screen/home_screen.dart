import 'package:flutter/material.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
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
        child: Text(Provider.of<User>(context)?.email ?? 'Parning'),
        onPressed: () {
          User user = Provider.of<User>(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Provider.value(
                      value: user, child: PairingScreen(widget._userId))));
        },
      )),
    );
  }
}
