import 'package:flutter/material.dart';
import 'package:karlekstanken/screens/test_screen/test_screen.dart';

import '../../../custom_icons_icons.dart';
import '../../../my_strings.dart';

class DoTest extends StatelessWidget {
  const DoTest();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, -3),
        )
      ]),
      child: InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => TestScreen())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(CustomIcons.form),
              SizedBox(
                width: 8,
              ),
              Text(
                MyStrings.doTheLoveLanguageTest,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          )),
    );
  }
}
