import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/completion_status.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/screens/chapter_screen/chapter_screen.dart';
import 'package:karlekstanken/screens/home_screen/widgets/do_test.dart';
import 'package:karlekstanken/screens/home_screen/widgets/my_progress_indicator.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:karlekstanken/widgets/chapter_list_item.dart';
import 'package:provider/provider.dart';

import 'checkable_chapter_list_item.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<Chapter>> _chaptersFuture;
  List<Chapter> _chapters;

  void _navigateToChapterScreen(Chapter chapter, bool licensed) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => new ChapterScreen(chapter, licensed)));
  }

  bool _isChapterCompleted(String id, Map<String, bool> chapters) {
    if (chapters != null && chapters[id] != null)
      return chapters[id];
    else
      return false;
  }

  int _getTasksTotal(List<Chapter> chapters) {
    if (chapters == null) return 0;

    int count = 0;
    chapters.forEach((Chapter chapter) {
      chapter.tasks?.forEach((_) => count++);
    });

    return count;
  }

  /* There can be completed tasks that doesn't actually exist in any of the chapters, 
  this is because as of right now when we delete a chapter or task from the database
  we don't delete any references to it. Therefore this method ignores completed tasks
  that dosen't exist anymore. */
  int _getCompletedTasksTotal(Map<String, bool> tasks, List<Chapter> chapters) {
    if (tasks == null || chapters == null) return 0;

    // ids of actual avaiable tasks from all chapters
    List<String> taskIds = chapters.fold([], (result, chapter) {
      chapter.tasks.forEach((task) {
        result.add(task.id);
      });
      return result;
    });

    int count = 0;
    tasks.forEach((id, completed) {
      if (taskIds.contains(id) && completed) count++;
    });

    return count;
  }

  // sets all tasks in chapter to either complete or incomplete
  void _onCheckTapped(Chapter chapter) {
    CoupleData coupleData = Provider.of<CoupleData>(context);
    if (coupleData == null) return;

    bool isChapterCompleted =
        !_isChapterCompleted(chapter.id, coupleData.completionStatus?.chapters);

    Map<String, bool> tasks = chapter.tasks.fold({}, (result, task) {
      result[task.id] = isChapterCompleted;
      return result;
    });

    Provider.of<DatabaseService>(context).updateChapterCompletionStatus(
        coupleDataRef: Provider.of<User>(context).coupleDataRef,
        chapterId: chapter.id,
        isChapterCompleted: isChapterCompleted,
        tasks: tasks);
  }

  void _getChapters() async {
    User user = Provider.of<User>(context);

    if (user == null) return;

    if (_chaptersFuture == null) {
      _chaptersFuture = Provider.of<DatabaseService>(context)
          .getChaptersWithTasks(user.licensed ? true : false);
    }
    List<Chapter> chapters = await _chaptersFuture;
    if (this.mounted) {
      setState(() {
        _chapters = chapters;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getChapters();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    CompletionStatus completionStatus =
        Provider.of<CoupleData>(context)?.completionStatus;

    bool showDoTestButton =
        user != null && user.licensed && user.loveLanguage == null;

    return Stack(children: <Widget>[
      if (user != null && _chapters != null)
        Container(
            margin: EdgeInsets.only(bottom: showDoTestButton ? 50 : 0),
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: 110,
                //bottom: showDoTestButton ? 60 : 0),
              ),
              itemBuilder: (context, position) {
                Chapter chapter = _chapters[position];

                return user.partner != null
                    ? CheckableChapterListItem(
                        completed: _isChapterCompleted(
                            chapter.id, completionStatus?.chapters),
                        disabled: chapter.isPreview,
                        title: chapter.title,
                        description: chapter.previewText,
                        onTap: () {
                          if (!chapter.isPreview) {
                            _navigateToChapterScreen(chapter, user.licensed);
                          }
                        },
                        onCheckTapped: () => _onCheckTapped(chapter),
                      )
                    : ChapterListItem(
                        completed: _isChapterCompleted(
                            chapter.id, completionStatus?.chapters),
                        disabled: chapter.isPreview,
                        title: chapter.title,
                        description: chapter.previewText,
                        onTap: () {
                          if (!chapter.isPreview) {
                            _navigateToChapterScreen(chapter, user.licensed);
                          }
                        },
                      );
              },
              itemCount: _chapters.length,
            )),
      Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: MyProgressIndicator(
                  _getTasksTotal(_chapters),
                  _getCompletedTasksTotal(
                      completionStatus?.tasks, _chapters)))),
      Visibility(
          visible: showDoTestButton,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: const DoTest(),
            /* Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child:
                            DoTestButton()), */
          ))
    ]);
  }
}
