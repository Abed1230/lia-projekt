import 'package:flutter/material.dart';
import 'package:karlekstanken/auth_error_codes.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karlekstanken/screens/sign_up_screen/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen(this.onSignedIn);

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  String _errorMessage;

  FirebaseUser _user;

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
        setState(() {
          _user = user;
        });
        widget.onSignedIn();
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

  void _navigateToSignUpScreen() {
    Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => new SignUpScreen()));
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
              FlatButton(
                child: Text(
                  MyStrings.signUpBtn,
                  style: TextStyle(color: Colors.black45),
                ),
                onPressed: _navigateToSignUpScreen,
              ),
              _user != null
                  ? Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Inloggad användarId: ${_user.uid}',
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
