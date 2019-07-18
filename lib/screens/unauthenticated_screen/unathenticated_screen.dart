import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:karlekstanken/screens/chapter_screen/chapter_screen.dart';
import 'package:karlekstanken/screens/sign_in_screen/sign_in_screen.dart';
import 'package:karlekstanken/screens/sign_up_screen/sign_up_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:provider/provider.dart';

class UnauthenticatedScreen extends StatefulWidget {
  UnauthenticatedScreen(this._onSignedIn);

  final VoidCallback _onSignedIn;

  @override
  State<StatefulWidget> createState() => new _UnauthenticatedScreenState();
}

class _UnauthenticatedScreenState extends State<UnauthenticatedScreen> {
  List<Chapter> _chapters = List();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getChapters();
  }

  void _getChapters() async {
    List<Chapter> c =
        await Provider.of<DatabaseService>(context).getChapters(false);
    if (this.mounted) {
      setState(() {
        _chapters = c;
      });
    }
  }

  void _navigateToChapterScreen(Chapter chapter) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ChapterScreen(chapter, false)));
  }

  void _navigateToSignInScreen() async {
    bool signedIn = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SignInScreen()));
    if (signedIn != null && signedIn) widget._onSignedIn();
  }

  void _navigateToSignUpScreen() async {
    bool signedIn = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => new SignUpScreen()));
    if (signedIn != null && signedIn) widget._onSignedIn();
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
                Chapter chapter = _chapters[position];
                return Card(
                    child: InkWell(
                        onTap: () {
                          if (!chapter.isPreview) {
                            _navigateToChapterScreen(chapter);
                          }
                        },
                        child: Container(
                            height: 90.0,
                            padding: EdgeInsets.all(8.0),
                            color: chapter.isPreview
                                ? Colors.black12
                                : Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  chapter.title,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  chapter.previewText,
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            ))));
              },
              itemCount: _chapters.length,
            ),
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
                  MyStrings.notSignedInMsg,
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
