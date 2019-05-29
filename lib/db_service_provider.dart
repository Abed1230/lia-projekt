import 'package:flutter/widgets.dart';
import 'package:karlekstanken/services/database.dart';

class DatabaseServiceProvider extends InheritedWidget {
  DatabaseServiceProvider({Key key, Widget child, this.db}) : super(key: key, child: child);

  final DatabaseService db;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static DatabaseServiceProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DatabaseServiceProvider) as DatabaseServiceProvider);
  }
}