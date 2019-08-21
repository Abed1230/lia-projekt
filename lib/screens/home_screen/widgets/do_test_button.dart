import 'package:flutter/material.dart';
import 'package:karlekstanken/screens/test_screen/test_screen.dart';

import '../../../custom_icons_icons.dart';
import '../../../my_strings.dart';

class DoTestButton extends StatelessWidget {
  const DoTestButton();

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        buttonColor: Theme.of(context).buttonColor,
        height: 50,
        minWidth: 180,
        child: RaisedButton.icon(
          icon: Icon(CustomIcons.form),
          label: Text(MyStrings.doTheLoveLanguageTest),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => TestScreen())),
        ));
  }
}
