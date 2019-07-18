import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/screens/home_screen/home_screen.dart';
import 'package:karlekstanken/screens/unauthenticated_screen/unathenticated_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

enum AuthStatus { UNDETERMINED, SIGNED_IN, NOT_SIGNED_IN }

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus _authStatus = AuthStatus.UNDETERMINED;
  String _userId;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.uid;
          _authStatus = AuthStatus.SIGNED_IN;
        } else {
          _authStatus = AuthStatus.NOT_SIGNED_IN;
        }
      });
    });
  }

  void _onSignedIn() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user.uid;
          _authStatus = AuthStatus.SIGNED_IN;
        }
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use onauthstatechanged to determine auth status
    switch (_authStatus) {
      case AuthStatus.UNDETERMINED:
        return _buildWaitingScreen();
      case AuthStatus.NOT_SIGNED_IN:
        return new UnauthenticatedScreen(_onSignedIn);
      case AuthStatus.SIGNED_IN:
        DatabaseService dbService = Provider.of<DatabaseService>(context);
        return new StreamProvider<User>.value(
            value: dbService.streamUser(_userId),
            child: new HomeScreen());
      default:
        return _buildWaitingScreen();
    }
  }
}
