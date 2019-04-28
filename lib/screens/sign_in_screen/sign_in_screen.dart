import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

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
    if(form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
     // Todo implement auth logic
    }
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
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
                validator: (value) => value.isEmpty ? MyStrings.emailRequired : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: MyStrings.password),
                obscureText: true,
                onSaved: (value) => _password = value,
                validator: (value) => value.isEmpty ? MyStrings.passwordRequired : null,
              ),
              _showErrorMessage(),
              RaisedButton(
                child: Text(MyStrings.signIn),
                onPressed: _validateAndSubmit,
              )
            ],
          ),
        ),
      ),
    );
  }
}