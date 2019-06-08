import 'package:flutter/material.dart';
import 'package:karlekstanken/db_service_provider.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/home_screen/home_screen.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
import 'package:karlekstanken/screens/root_screen.dart';
import 'package:karlekstanken/services/database.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DatabaseServiceProvider(
        db: new DatabaseService(),
        child: new MaterialApp(
            title: MyStrings.appName,
            home: PairingScreen(), //new RootScreen(),
            routes: <String, WidgetBuilder>{
              'home': (BuildContext context) => new HomeScreen(),
            }));
  }
}
