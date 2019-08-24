import 'package:flutter/material.dart';

class CheckableChapterListItem extends StatelessWidget {
  CheckableChapterListItem(
      {this.completed,
      this.disabled,
      this.title,
      this.description,
      this.onTap,
      this.onCheckTapped});

  final bool completed;
  final bool disabled;
  final String title;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onCheckTapped;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Container(
                height: 90.0,
                padding: EdgeInsets.all(8.0),
                color: disabled ? Colors.black12 : Colors.white,
                child: !disabled
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                description,
                                style: TextStyle(color: Colors.black54),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          )),
                          VerticalDivider(),
                          Icon(
                            Icons.check_circle,
                            color: completed ? Colors.green : Colors.grey,
                          )
                        ],
                      )
                    : Column(
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ))));
  }
}
