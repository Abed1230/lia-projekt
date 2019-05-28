import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/sign_in_screen/sign_in_screen.dart';
import 'package:karlekstanken/screens/sign_up_screen/sign_up_screen.dart';
import 'package:karlekstanken/services/database.dart';

class UnauthenticatedScreen extends StatefulWidget {
  UnauthenticatedScreen(this.onSignedIn);

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _UnauthenticatedScreenState();
}

class _UnauthenticatedScreenState extends State<UnauthenticatedScreen> {
  final db = DatabaseService();
  List<Chapter> chapters = List();

  @override
  void initState() {
    super.initState();
    getChapters();
  }

  void getChapters() async {
    List<Chapter> c = await db.getChapters();
    setState(() {
      chapters = c;
    });
  }

  void _navigateToSignInScreen() async {
    bool signedIn = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SignInScreen()));
    if (signedIn != null && signedIn) widget.onSignedIn();
  }

  void _navigateToSignUpScreen() async {
    bool signedIn = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SignUpScreen()));
    if (signedIn != null && signedIn) widget.onSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Todo: replace with logo
        title: Center(child: Text(MyStrings.appName)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                Chapter chapter = chapters[position];
                return Card(
                    child: Container(
                        height: 90.0,
                        padding: EdgeInsets.all(8.0),
                        color: chapter.isPaid ? Colors.black12 : Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              chapter.title,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              chapter.description,
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        )));
              },
              itemCount: chapters.length,
            ),
            /* child: StreamBuilder(
            stream: Firestore.instance.collection('chapters').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('no data');
              }

              return ListView.builder(
                itemBuilder: (context, position) {
                  DocumentSnapshot chapter = snapshot.data.documents[position];
                  return Card(
                      child: Container(
                          height: 90.0,
                          padding: EdgeInsets.all(8.0),
                          color: _sections[position].locked
                              ? Colors.black12
                              : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                chapter['title'],
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                chapter['description'],
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          )));
                },
                itemCount: snapshot.data.documents.length,
              );
            },
          ) */
          ),
          // Todo: fix height on landscape mode
          Container(
            padding: EdgeInsets.all(8.0),
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 20.0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Du är inte inloggad och därmed begränsad till introduktionen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
                MyRoundedButton(
                    text: MyStrings.signIn, onPressed: _navigateToSignInScreen),
                MyRoundedButton(
                    text: MyStrings.signUp, onPressed: _navigateToSignUpScreen)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyRoundedButton extends StatelessWidget {
  const MyRoundedButton({this.text, this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Text(text),
      onPressed: onPressed,
    );
  }
}
