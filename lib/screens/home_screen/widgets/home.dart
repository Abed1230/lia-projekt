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
    int count = 0;
    chapters.forEach((Chapter chapter) {
      chapter.tasks?.forEach((_) => count++);
    });

    return count;
  }

  int _getCompletedTasksTotal(Map<String, bool> tasks) {
    if (tasks == null) return 0;

    int count = 0;
    tasks.forEach((id, completed) {
      if (completed) count++;
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

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    CompletionStatus completionStatus =
        Provider.of<CoupleData>(context)?.completionStatus;

    bool showDoTestButton =
        user != null && user.licensed && user.loveLanguage == null;

    return user != null
        ? FutureBuilder(
            future: Provider.of<DatabaseService>(context)
                .getChaptersWithTasks(user.licensed ? true : false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              List<Chapter> chapters = snapshot.data;

              return Stack(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: showDoTestButton ? 50 : 0),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        top: 110,
                        //bottom: showDoTestButton ? 60 : 0),
                      ),
                      itemBuilder: (context, position) {
                        Chapter chapter = chapters[position];

                        return user.partner != null
                            ? CheckableChapterListItem(
                                completed: _isChapterCompleted(
                                    chapter.id, completionStatus?.chapters),
                                disabled: chapter.isPreview,
                                title: chapter.title,
                                description: chapter.previewText,
                                onTap: () {
                                  if (!chapter.isPreview) {
                                    _navigateToChapterScreen(
                                        chapter, user.licensed);
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
                                    _navigateToChapterScreen(
                                        chapter, user.licensed);
                                  }
                                },
                              );
                      },
                      itemCount: chapters.length,
                    )),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: MyProgressIndicator(_getTasksTotal(chapters),
                            _getCompletedTasksTotal(completionStatus?.tasks)))),
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
            },
          )
        : SizedBox();
  }
}
