import 'package:flutter/material.dart';
import 'package:karlekstanken/auth_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _name;
  String _email;
  String _password;
  String _errorMessage = '';

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
        // Create user document in datbaase
        Firestore.instance.collection('users').document(user.uid).setData({'licensed' : false});
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
                decoration: InputDecoration(labelText: MyStrings.fullName),
                keyboardType: TextInputType.text,
                onSaved: (value) => _name = value,
                validator: (value) =>
                    value.isEmpty ? MyStrings.nameRequired : null,
              ),
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
                child: Text(MyStrings.signUp),
                onPressed: _validateAndSubmit,
              ),
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
