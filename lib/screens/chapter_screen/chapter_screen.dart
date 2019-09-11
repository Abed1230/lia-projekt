import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/completion_status.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/screens/chapter_screen/widgets/task_list_item.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:karlekstanken/utils/util_functions.dart';
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

  DatabaseService _dbService;
  User _user;
  CoupleData _coupleData;
  CompletionStatus _completionStatus;

  @override
  void initState() {
    super.initState();
    _chapter = widget._chapter;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _dbService = Provider.of<DatabaseService>(context);
    _user = Provider.of<User>(context);
    _coupleData = Provider.of<CoupleData>(context);
    _completionStatus = _coupleData?.completionStatus;

    _getTasks();
  }

  void _getTasks() async {
    List<Task> tasks = await _dbService.getTasks(_chapter.id, widget._licensed);
    if (this.mounted) {
      setState(() {
        _tasks = tasks;
      });
    }
  }

  void onTaskTapped(String taskId) {
    if (_coupleData == null) return;

    // Reverse completion
    bool isTaskCompleted = !_isTaskCompleted(taskId, _completionStatus?.tasks);
    // Add all tasksids except provided taskId to list
    List<String> taskIds = _tasks.fold([], (result, task) {
      if (task.id != taskId) {
        result.add(task.id);
      }
      return result;
    });

    bool isChapterCompleted =
        isTaskCompleted && _isTasksCompleted(taskIds, _completionStatus?.tasks);

    _dbService.updateChapterCompletionStatus(
        coupleDataRef: _user.coupleDataRef,
        chapterId: _chapter.id,
        isChapterCompleted: isChapterCompleted,
        tasks: {taskId: isTaskCompleted});
  }

  bool _isTaskCompleted(String id, Map<String, bool> tasks) {
    if (tasks != null && tasks[id] != null)
      return tasks[id];
    else
      return false;
  }

  bool _isTasksCompleted(List<String> taskIds, Map<String, bool> tasks) {
    if (tasks == null) return false;
    int count = 0;
    for (String id in taskIds) {
      if (tasks[id] != null && tasks[id]) count++;
    }
    return count == taskIds.length;
  }

  @override
  Widget build(BuildContext context) {
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
                  if (_chapter.videoUrls != null &&
                      UtilFunctions.inBounds(0, _chapter.videoUrls)) ...[
                    MyVideoPlayer(_chapter.videoUrls[0]),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                  if (_chapter.videoUrls != null &&
                      UtilFunctions.inBounds(1, _chapter.videoUrls))
                    MyVideoPlayer(_chapter.videoUrls?.elementAt(1)),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(_chapter.mainText),
                  ),
                  if (_chapter.audioUrl != null)
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
                              completed: _isTaskCompleted(
                                  task.id, _completionStatus?.tasks),
                              title: task.title,
                              onTap: () => onTaskTapped(task.id),
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
