import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/models/chapter.dart';
import 'package:karlekstanken/db_service_provider.dart';
import 'package:karlekstanken/my_colors.dart';
import 'package:karlekstanken/screens/chapter_screen/audio_player.dart';
import 'package:video_player/video_player.dart';

class ChapterScreen extends StatefulWidget {
  ChapterScreen(this._chapter);

  final Chapter _chapter;

  @override
  _ChapterScreenState createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Chapter _chapter;
  List<Task> _tasks;

  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chapter = widget._chapter;

    _videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getTasks();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _getTasks() async {
    List<Task> tasks;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      tasks =
          await DatabaseServiceProvider.of(context).db.getTasks(_chapter.id);
    } else {
      tasks = await DatabaseServiceProvider.of(context)
          .db
          .getTasksUnauthenticated(_chapter.id);
    }

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
          //new VideoPlayerScreen(),
          Chewie(
            controller: _chewieController,
          ),
          Text(_chapter.video),
          Text(_chapter.text),
          new MyAudioPlayer(),
          Expanded(
            child: _tasks == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, pos) {
                      return GestureDetector(
                        onTap: () {},
                        child: ExerciseBox(_tasks[pos].title, false),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class ExerciseBox extends StatelessWidget {
  final String title;
  final bool complete;

  ExerciseBox(this.title, this.complete);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        color: MyColors.secondary,
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(45, 15, 50, 15),
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        complete
                            ? new Container(
                                padding: EdgeInsets.fromLTRB(45, 0, 50, 0),
                                child: Text(
                                  'Färdig',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[500],
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ]),
                ),
              ),
            ]),
      ),
    );
  }
}
