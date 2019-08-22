import 'package:flutter/material.dart';
import 'package:karlekstanken/my_strings.dart';

class LoveLanguageCard extends StatelessWidget {
  LoveLanguageCard({this.header, this.text, this.onTap});

  final String header;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(header),
              Divider(),
              Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
              Divider(),
              InkWell(
                  onTap: onTap,
                  child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        MyStrings.showDescription,
                        textAlign: TextAlign.center,
                      )))
            ],
          )),
    );
  }
}
