import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/other_user.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/pairing_screen/pairing_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _navigateToPairingScreen() {
    String userId = Provider.of<FirebaseUser>(context).uid;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => StreamProvider<User>.value(
                value: Provider.of<DatabaseService>(context).streamUser(userId),
                child: PairingScreen(userId))));
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    OtherUser partner =
        user.partner != null ? OtherUser.fromMap(user.partner) : null;
    return user != null
        ? SizedBox.expand(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 10),
                  child: Text(
                    partner != null
                        ? '${MyStrings.you} & ${partner.name}'
                        : '${MyStrings.you} & ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300),
                  )),
              partner == null
                  ? FlatButton(
                      child: Text(
                        MyStrings.addPartner,
                      ),
                      onPressed: _navigateToPairingScreen,
                    )
                  : SizedBox()
            ],
          ))
        : SizedBox();
  }
}
