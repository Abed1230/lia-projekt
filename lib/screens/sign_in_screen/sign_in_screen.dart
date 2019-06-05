import 'package:flutter/material.dart';
import 'package:karlekstanken/auth_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _validateAndSave() {
    FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.pop(context, true);
      } catch (e) {
        String msg = '';
        switch (e.code) {
          case AuthErrorCodes.errorInvalidEmail:
            msg = MyStrings.invalidEmail;
            break;
          case AuthErrorCodes.errorWrongPassword:
            msg = MyStrings.wrongPassword;
            break;
          case AuthErrorCodes.errorUserNotFound:
            msg = MyStrings.userNotFoundMsg;
            break;
          default:
            msg = MyStrings.unknownErrorMsg;
            break;
        }
        setState(() {
          _errorMessage = msg;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.signInScreenTitle),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: MyStrings.email),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value,
                validator: (value) =>
                    value.isEmpty ? MyStrings.emailRequired : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: MyStrings.password),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) =>
                    value.isEmpty ? MyStrings.passwordRequired : null,
              ),
              _showErrorMessage(),
              RaisedButton(
                child: Text(MyStrings.signIn),
                onPressed: _validateAndSubmit,
              ),
              /* FlatButton(
                child: Text(
                  MyStrings.signUpBtn,
                  style: TextStyle(color: Colors.black45),
                ),
                onPressed: _navigateToSignUpScreen,
              ), */
            ],
          ),
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0) {
      return new Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
