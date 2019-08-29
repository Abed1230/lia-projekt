import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/couple_data.dart';
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
                child: MyCoupleDataProxy(
                    child: new MaterialApp(
              title: MyStrings.appName,
              home: RootScreen(),
            )))));
  }
}

// User Proxy

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

// Couple Data Proxy

class MyCoupleDataProxy extends StatefulWidget {
  final Widget child;

  MyCoupleDataProxy({this.child});

  @override
  _MyCoupleDataProxyState createState() => _MyCoupleDataProxyState();
}

class _MyCoupleDataProxyState extends State<MyCoupleDataProxy> {
  Stream<CoupleData> _coupleDataStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final DocumentReference coupleDataRef =
        Provider.of<User>(context)?.coupleDataRef;
    _coupleDataStream =
        Provider.of<DatabaseService>(context).streamCoupleData(coupleDataRef);
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CoupleData>.value(
      value: _coupleDataStream,
      child: widget.child,
    );
  }
}
