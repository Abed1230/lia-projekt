import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/progress.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/screens/chapter_screen/widgets/task_list_item.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:karlekstanken/widgets/my_audio_player.dart';
import 'package:karlekstanken/widgets/my_video_player.dart';
import 'package:provider/provider.dart';

class ChapterScreen extends StatefulWidget {
  ChapterScreen(this._chapter, this._licensed);

  final Chapter _chapter;
  final bool _licensed;

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
    List<Task> tasks = await Provider.of<DatabaseService>(context)
        .getTasks(_chapter.id, widget._licensed);
    if (this.mounted) {
      setState(() {
        _tasks = tasks;
      });
    }
  }

  void onTaskTapped(Progress progress, Task task) {
    if (progress == null) return;

    // Reverse completion
    bool isTaskCompleted = !progress.isTaskCompleted(task.id);

    List<String> taskIds = _tasks.fold([], (res, t) {
      if (t.id != task.id) {
        res.add(t.id);
      }
      return res;
    });

    bool isChapterCompleted =
        isTaskCompleted && progress.isAllTasksCompleted(taskIds);

    Provider.of<DatabaseService>(context).updateChapterCompletionStatus(
        Provider.of<User>(context).coupleDataRef,
        _chapter.id,
        isChapterCompleted,
        task.id,
        isTaskCompleted);
  }

  @override
  Widget build(BuildContext context) {
    Progress progress = Provider.of<CoupleData>(context)?.progress;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text(_chapter.title),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  MyVideoPlayer(_chapter.videoUrls?.elementAt(0)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  MyVideoPlayer(_chapter.videoUrls?.elementAt(1)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(_chapter.mainText),
                  ),
                  MyAudioPlayer(url: _chapter.audioUrl),
                  _tasks == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _tasks.length,
                          itemBuilder: (context, pos) {
                            Task task = _tasks[pos];
                            return TaskListItem(
                              completed:
                                  progress?.isTaskCompleted(task.id) ?? false,
                              title: task.title,
                              onTap: () => onTaskTapped(progress, task),
                            );
                          }),
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}
