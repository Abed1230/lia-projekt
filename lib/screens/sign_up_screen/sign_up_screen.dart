import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/auth_error_codes.dart';
import 'package:karlekstanken/my_colors.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TODO: update with correct url
  static const _TERMS_AND_CONDITIONS_URL =
      'http://www.kärlekstanken.se/privacypolicy.php';
  static const _PRIVACY_POLICY_URL =
      'http://www.kärlekstanken.se/privacypolicy.php';

  final _formKey = new GlobalKey<FormState>();

  String _name;
  String _email;
  String _password;
  String _errorMessage = '';

  bool _termsChecked = false;
  bool _showCheckBoxErrorMsg = false;

  bool _validateAndSave() {
    setState(() {
      _showCheckBoxErrorMsg = false;
    });

    FormState form = _formKey.currentState;
    form.save();
    if (form.validate() && _termsChecked) {
      return true;
    }

    if (!_termsChecked) {
      setState(() {
        _showCheckBoxErrorMsg = true;
      });
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        // Create user document in datbaase
        Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({'licensed': false});
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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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
              _buildTermsConditionsCheckbox(),
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

  Widget _buildTermsConditionsCheckbox() {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: _termsChecked,
                  onChanged: (bool value) =>
                      setState(() => _termsChecked = value),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: RichText(
                  softWrap: true,
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: '${MyStrings.iAccept} '),
                        TextSpan(
                            text: '${MyStrings.theUserTerms} ',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap =
                                  () => _launchURL(_TERMS_AND_CONDITIONS_URL)),
                        TextSpan(text: '${MyStrings.andHaveRead} '),
                        TextSpan(
                            text: MyStrings.thePrivacyPolicy,
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _launchURL(_PRIVACY_POLICY_URL)),
                      ]),
                )),
              ],
            ),
            if (_showCheckBoxErrorMsg)
              Padding(
                padding: EdgeInsets.only(left: 58),
                child: Text(
                  MyStrings.isRequired,
                  style: TextStyle(color: MyColors.errorRed, fontSize: 12),
                ),
              ),
          ],
        ));
  }
}
