import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/models/couple_data.dart';
import 'package:karlekstanken/models/progress.dart';
import 'package:karlekstanken/models/user.dart';
import 'package:karlekstanken/screens/chapter_screen/chapter_screen.dart';
import 'package:karlekstanken/services/database.dart';
import 'package:karlekstanken/widgets/chapter_list_item.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    Progress progress = Provider.of<CoupleData>(context)?.progress;
  
    return user != null
        ? FutureBuilder(
            future: Provider.of<DatabaseService>(context)
                .getChapters(user.licensed ? true : false),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return SizedBox();

              List<Chapter> chapters = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, position) {
                  Chapter chapter = chapters[position];
                  return ChapterListItem(
                    completed: progress != null
                        ? progress.isChapterCompleted(chapter.id)
                        : false,
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
                itemCount: chapters.length,
              );
            },
          )
        : SizedBox();
  }
}
