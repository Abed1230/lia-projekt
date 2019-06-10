import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyAudioPlayer extends StatefulWidget {
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
      await audioPlayer.play(
          'https://api.soundcloud.com/tracks/434370309/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P');
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
        color: Colors.black,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new RaisedButton(
              child: playing ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              onPressed: () {
                playRemote();
              },
            ),
          ],
        ),
      ),
    );
  }
}
