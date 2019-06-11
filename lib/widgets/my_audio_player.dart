import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/my_colors.dart';

class MyAudioPlayer extends StatefulWidget {
  MyAudioPlayer(this._url);

  String _url;

  @override
  _MyAudioPlayer createState() => new _MyAudioPlayer();
}

class _MyAudioPlayer extends State<MyAudioPlayer> {
  static AudioCache advancedPlayer = new AudioCache(prefix: 'tracks/');
  static AudioPlayer audioPlayer = new AudioPlayer();
  bool playing = false;
  double sliderValue = 0;

  @override
  initState() {
    super.initState();
  }

  Future loadMusic() async {
    //advancedPlayer = await AudioCache().loop("assets/tracks/gg.mp3");
  }
  playLocal() async {
    advancedPlayer.play('gg.mp3');
  }

  playRemote() async {
    getTrackPosition();
    if (playing == false) {
      await audioPlayer.play(widget._url);
      setState(() {
        playing = true;
      });
    } else if (playing == true) {
      await audioPlayer.pause();
      setState(() {
        playing = false;
      });
    }
  }

  getTrackPosition() {
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      return p;
    });
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        color: MyColors.secondaryVariant,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Lyssna', style: TextStyle(color: Colors.white,fontSize: 30),
            ),
            ButtonTheme(
              minWidth: 100.0,
              height: 100.0,
              child: new FlatButton(
                child: playing
                    ? Icon(Icons.pause_circle_outline, size: 80, color: Colors.white,)
                    : Icon(Icons.play_circle_outline, size: 80,color: Colors.white,),
                onPressed: () {
                  playRemote();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
