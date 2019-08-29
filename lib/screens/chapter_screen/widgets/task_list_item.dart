import 'package:flutter/material.dart';

class TaskListItem extends StatelessWidget {
  TaskListItem({this.completed, this.title, this.onTap});

  final bool completed;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70.0,
          padding: EdgeInsets.all(8.0),
          color: completed ? Colors.green : Colors.white,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}