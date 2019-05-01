import 'package:flutter/material.dart';
import 'package:karlekstanken/auth_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  String _errorMessage;

  FirebaseUser _user;

  bool _validateAndSave() {
    FormState form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pop(context, true);
      } catch (e) {
        String msg = '';
        switch (e.code) {
          case AuthErrorCodes.errorInvalidEmail:
            msg = MyStrings.invalidEmail;
            break;
          case AuthErrorCodes.errorWeakPassword:
            msg = MyStrings.shortPasswordMsg;
            break;
          case AuthErrorCodes.errorEmailAlreadyInUse:
            msg = MyStrings.emailAlreadyInUseMsg;
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

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
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

  String _validateSecondPasswordField(String value) {
    if (value.isEmpty) {
      return MyStrings.passwordRequired;
    } else if (value != _password) {
      return MyStrings.passwordMismatchMsg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyStrings.signUpScreenTitle),
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
              TextFormField(
                decoration:
                    InputDecoration(labelText: MyStrings.repeatPassword),
                obscureText: true,
                validator: _validateSecondPasswordField,
              ),
              _showErrorMessage(),
              RaisedButton(
                child: Text(MyStrings.signUp),
                onPressed: _validateAndSubmit,
              ),
              _user != null
                  ? Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Registrerad och inloggad, användarId: ${_user.uid}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.green,
                        ),
                      ),
                    )
                  : Container(
                      height: 0.0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
