import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/db_service_provider.dart';

class ChapterScreen extends StatefulWidget {
  ChapterScreen(this._chapter);

  final Chapter _chapter;

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Chapter _chapter;
  List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _chapter = widget._chapter;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getTasks();
  }

  void _getTasks() async {
    List<Task> tasks = await DatabaseServiceProvider.of(context).db.getTasks(_chapter.id);
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chapter.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(_chapter.video),
          Text(_chapter.text),
          Expanded(
            child: _tasks == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, pos) {
                      return ListTile(
                        title: Text(_tasks[pos].title),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
