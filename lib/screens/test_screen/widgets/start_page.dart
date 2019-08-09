import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';
import 'package:provider/provider.dart';

import '../test_screen.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<TestState>(context);

    return Padding(
        padding: EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              MyStrings.testTitle,
              style: TextStyle(fontSize: 18),
            ),
            Divider(),
            Expanded(
              child: Text(
                MyStrings.testDescription,
                textAlign: TextAlign.start,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(MyStrings.start),
                  onPressed: () => state.nextPage(),
                ),
              ],
            )
          ],
        ));
  }
}
