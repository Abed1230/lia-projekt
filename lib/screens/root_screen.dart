import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/screens/home_screen/home_screen.dart';
import 'package:karlekstanken/screens/sign_in_screen/sign_in_screen.dart';

enum AuthStatus {
  UNDETERMINED,
  SIGNED_IN,
  NOT_SIGNED_IN
}

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
          _userId = user?.uid;
        } 
        _authStatus = user?.uid == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  void _onSignedIn() {
    setState(() {
      FirebaseAuth.instance.currentUser().then((user) {
        _userId = user.uid;
      });
      _authStatus = AuthStatus.SIGNED_IN;
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
    switch(_authStatus) {
      case AuthStatus.UNDETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_SIGNED_IN:
        return new SignInScreen(_onSignedIn);
        break;
      case AuthStatus.SIGNED_IN:
        if (_userId != null && _userId.length > 0) {
          return new HomeScreen(_userId);
        } else {
          return _buildWaitingScreen();
        }
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}