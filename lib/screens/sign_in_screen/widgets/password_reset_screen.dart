import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/utils/validators.dart';
import 'package:karlekstanken/widgets/error_message.dart';

import '../../../auth_error_codes.dart';
import '../../../my_strings.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen(this._email);

  final String _email;

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = new GlobalKey<FormState>();

  String _email;

  String _errorMessage = '';

  bool _sent = false;

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
        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
        setState(() {
          _sent = true;
        });
      } catch (e) {
        String msg = '';
        switch (e.code) {
          case AuthErrorCodes.errorInvalidEmail:
            msg = MyStrings.invalidEmail;
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyStrings.passwordResetScreenTitle),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
            child: _sent
                ? Center(
                    child: Text(
                      MyStrings.passwordResetSentMsg,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            MyStrings.passwordResetInfo,
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            initialValue: widget._email,
                            decoration:
                                InputDecoration(labelText: MyStrings.email),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) => _email = value,
                            validator: (value) =>
                                Validators.validateEmail(value)
                                    ? null
                                    : MyStrings.invalidEmail,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          if (_errorMessage.length > 0)
                            ErrorMessage(_errorMessage),
                          RaisedButton(
                            child: Text(MyStrings.send),
                            onPressed: _validateAndSubmit,
                          )
                        ]))));
  }
}
