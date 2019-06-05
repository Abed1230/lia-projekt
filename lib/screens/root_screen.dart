import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/screens/home_screen/home_screen.dart';
import 'package:karlekstanken/screens/sign_in_screen/sign_in_screen.dart';
import 'package:karlekstanken/screens/unauthenticated_screen/unathenticated_screen.dart';

enum AuthStatus { UNDETERMINED, SIGNED_IN, NOT_SIGNED_IN }

class RootScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthStatus _authStatus = AuthStatus.UNDETERMINED;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        user == null
            ? _authStatus = AuthStatus.NOT_SIGNED_IN
            : _authStatus = AuthStatus.SIGNED_IN;
      });
    });
  }

  void _onSignedIn() {
    setState(() {
      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) _authStatus = AuthStatus.SIGNED_IN;
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
    switch (_authStatus) {
      case AuthStatus.UNDETERMINED:
        return _buildWaitingScreen();
      case AuthStatus.NOT_SIGNED_IN:
        return new UnauthenticatedScreen(_onSignedIn);
      case AuthStatus.SIGNED_IN:
        return new HomeScreen();
      default:
        return _buildWaitingScreen();
    }
  }
}
