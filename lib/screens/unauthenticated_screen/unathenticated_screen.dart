import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class Section {
  Section(this.locked, this.title, this.description);
  bool locked;
  String title;
  String description;
}

class UnauthenticatedScreen extends StatefulWidget {
  UnauthenticatedScreen(this.onSignedIn);

  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _UnauthenticatedScreenState();
}

class _UnauthenticatedScreenState extends State<UnauthenticatedScreen> {
  List<Section> _sections;

  @override
  void initState() {
    super.initState();
    _sections = List();
    _sections.add(Section(false, 'Avsnitt 1 - Introduktion', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 2', 'Lorem ipsum dolor sit amet'));
    _sections.add(Section(true, 'Avsnitt 3', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 4', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 5', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 6', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 7', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 8', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 9', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
    _sections.add(Section(true, 'Avsnitt 10', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sollicitudin at nunc non finibus. Mauris ultrices imperdiet fermentum.'));
  }

  void _navigateToSignInScreen() async {}

  void _navigateToSignUpScreen() async {}

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
              return Card(
                  child: Container(
                      height: 90.0,
                      padding: EdgeInsets.all(8.0),
                      color: _sections[position].locked ? Colors.black12 : Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _sections[position].title,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _sections[position].description,
                            style: TextStyle(color: Colors.black54),
                          )
                        ],
                      )));
            },
            itemCount: _sections.length,
          )),
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
                MyRoundedButton(text: MyStrings.signIn, onPressed: _navigateToSignInScreen),
                MyRoundedButton(text: MyStrings.signUp, onPressed: _navigateToSignUpScreen)
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
