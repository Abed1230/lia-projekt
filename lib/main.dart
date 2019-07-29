import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/root_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Provider<DatabaseService>.value(
        value: DatabaseService(),
        child: new StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged,
            child: MyUserProxy(
                child: new MaterialApp(
              title: MyStrings.appName,
              home: RootScreen(),
            ))));
  }
}

class MyUserProxy extends StatefulWidget {
  final Widget child;

  MyUserProxy({this.child});

  @override
  _MyUserProxyState createState() => _MyUserProxyState();
}

class _MyUserProxyState extends State<MyUserProxy> {
  Stream<User> _userStream;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final String uid = Provider.of<FirebaseUser>(context)?.uid;
    _userStream = Provider.of<DatabaseService>(context).streamUser(uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: _userStream,
      child: widget.child,
    );
  }
}
