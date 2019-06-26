import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:karlekstanken/my_colors.dart';

enum PlayerState { stopped, playing, paused }

class MyAudioPlayer extends StatefulWidget {
  
 final String url;
  final bool isLocal;
  final PlayerMode mode;

  MyAudioPlayer(
      {@required this.url,
      this.isLocal = false,
      this.mode = PlayerMode.MEDIA_PLAYER});

   @override
  State<StatefulWidget> createState() {
    return new _MyAudioPlayer(url, isLocal, mode);
  }
}

class _MyAudioPlayer extends State<MyAudioPlayer> {
  //static AudioCache advancedPlayer = new AudioCache(prefix: 'tracks/');

  String url;
  bool isLocal;
  PlayerMode mode;

  static AudioPlayer _audioPlayer = new AudioPlayer();
  static AudioPlayerState _audioPlayerState;
  Duration _duration = new Duration();
  Duration _position = new Duration(); 
  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

 _MyAudioPlayer(this.url, this.isLocal, this.mode);

  @override
  initState() {
    super.initState();
    loadMusic();
    subscribeDuration();
    subscribePosition();
  }

  void subscribeDuration(){
    _durationSubscription = _audioPlayer.onDurationChanged.listen((Duration d) {
    print('Max duration: $d');
    setState(() => _duration = d);
  });
  }

  void subscribePosition(){
      _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((Duration  p) {
    print('Current position: $p');
    setState(() => _position = p);
  });
  }

    void getTrackPosition() {
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      return p;
    });
  }

  void loadMusic() {
        _audioPlayer.setUrl(url);
        _playerState = PlayerState.paused;
  }

  playRemote() async {
    getTrackPosition();
    if (_playerState == PlayerState.paused) {
      await _audioPlayer.play(url);
      setState(() {
        _playerState = PlayerState.playing;
      });
    } else if (_playerState == PlayerState.playing) {
      await _audioPlayer.pause();
      setState(() {
        _playerState = PlayerState.paused;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Card(
        color: MyColors.secondaryVariant,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Text('Lyssna'),
            ButtonTheme(
              height: 100.0,
              child: new FlatButton(
                child: 
                _playerState == PlayerState.playing ? Icon(
                        Icons.pause_circle_outline,
                        size: 40,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_circle_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                onPressed: () {
                  playRemote();
                },
              ),
            ),
          
            new Slider(
                value: _position?.inSeconds?.toDouble() ?? 0,
                onChanged: (double value) =>
                    _audioPlayer.seek(Duration(seconds : value.toInt())),
                min: 0.0,
                max: _duration.inSeconds.toDouble()),
          ],
        ),
      ),
    );
  }
}
