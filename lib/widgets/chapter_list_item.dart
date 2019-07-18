import 'package:flutter/material.dart';

class ChapterListItem extends StatelessWidget {
  ChapterListItem({this.disabled, this.title, this.description, this.onTap});

  final bool disabled;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 90.0,
                padding: EdgeInsets.all(8.0),
                color: disabled ? Colors.black12 : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      description,
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ))));
  }
}