import 'package:flutter/material.dart';
import 'package:karlekstanken/db_service_provider.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/root_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Provider(
        builder: (context) => DatabaseService(),
        child: new DatabaseServiceProvider(
            db: new DatabaseService(),
            child: new MaterialApp(
              title: MyStrings.appName,
              home: RootScreen(),
            )));
  }
}
